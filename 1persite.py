#!/usr/bin/python

import sys
import gzip
import resource
import random
from optparse import OptionParser
from collections import defaultdict


def create_parser(): # {{{
	def open_node_list(option, _optstr, value, parser): # {{{
		if value.endswith('.gz'): fd = gzip.open(value, 'r')
		else: fd = open(value, 'r')
		nodelist = list(set([l.strip() for l in fd]))
		setattr(parser.values, option.dest, nodelist)
	# }}}
	def open_outfd(option, _optstr, value, parser): # {{{
		if value.endswith('.gz'): fd = gzip.open(value, 'w')
		else: fd = open(value, 'w')
		setattr(parser.values, option.dest, fd)
	# }}}

	parser = OptionParser()

	parser.add_option('-i',
			dest='nodelist',
			metavar='FILE',
			action='callback',
			callback=open_node_list,
			nargs=1, type='str',
			help='working node list, one per line')

	parser.add_option('-o',
			dest='outfd',
			metavar='FILE',
			action='callback',
			callback=open_outfd,
			nargs=1, type='str',
			default=sys.stdout,
			help='output file [stdout]')

	return parser
# }}}


def one_per_site(nodelist, outfd): # {{{
	suffix2nodes = defaultdict(list)
	for node in nodelist:
		fields = node.split('.')
		suffix = '.'.join(fields[1:])
		suffix2nodes[suffix].append(node)
	for suffix, nodes in suffix2nodes.items():
		outfd.write(random.choice(nodes) + '\n')
# }}}


def main(): # {{{
	parser = create_parser()
	opts, _args = parser.parse_args()
	if opts.nodelist is None:
		parser.parse_args(['-h'])

	resource.setrlimit(resource.RLIMIT_AS, (2147483648L, 2147483648L))

	one_per_site(opts.nodelist, opts.outfd)
# }}}


if __name__ == '__main__':
	sys.exit(main())
