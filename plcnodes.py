#!/usr/bin/env python2

import sys
import resource
import xmlrpclib
from optparse import OptionParser


XMLRPC_EU = 'https://www.planet-lab.eu/PLCAPI/'
XMLRPC_US = 'https://www.planet-lab.org/PLCAPI/'


def create_parser(): # {{{
	usage = 'usage: %prog [--user=LOGIN] --pass=PASS'
	parser = OptionParser(usage=usage)

	parser.add_option('--us',
			dest='xmlrpc',
			action='store_const',
			const=XMLRPC_US,
			help='set XMLRPC server to planet-lab.org (US)')

	parser.add_option('--eu',
			dest='xmlrpc',
			action='store_const',
			const=XMLRPC_EU,
			help='set XMLRPC server to planet-lab.eu (EU)')

	parser.add_option('--delete',
			dest='add',
			action='store_false',
			help='delete nodes from slice')

	parser.add_option('--add',
			dest='add',
			action='store_true',
			help='add nodes to slice')

	parser.add_option('--user',
			dest='user',
			metavar='LOGIN',
			type='str',
			default='italocunha@gmail.com',
			# also italocunha+thlabpl@gmail.com
			help='username to use for login [%default]')

	parser.add_option('--nodefile',
			dest='nodelist',
			type='str',
			help='file containing list of nodes')

	parser.add_option('--slice',
			dest='slice',
			type='str',
			help='PL slice to add nodes to')

	parser.add_option('--pass',
			dest='passwd',
			metavar='PASS',
			type='str',
			help='password for LOGIN')

	return parser
# }}}


def main():
	resource.setrlimit(resource.RLIMIT_AS, (2147483648L, 2147483648L))

	parser = create_parser()
	opts, _args = parser.parse_args()
	if opts.add is None or opts.passwd is None or opts.xmlrpc is None:
		parser.parse_args(['-h'])

	api_server = xmlrpclib.ServerProxy(opts.xmlrpc)

	auth = dict()
	auth['Username'] = opts.user
	auth['AuthString'] = opts.passwd
	auth['AuthMethod'] = 'password'

	nodes = [line.strip() for line in open(opts.nodelist)]

	if opts.add:
		api_server.AddSliceToNodes(auth, opts.slice, nodes)
	else:
		api_server.DeleteSliceFromNodes(auth, opts.slice, nodes)


if __name__ == '__main__':
	sys.exit(main())


