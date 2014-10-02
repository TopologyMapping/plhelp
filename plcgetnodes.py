#!/usr/bin/env python2
# TODO: this script does not specify which slice to get nodes for; it may break
# if an e-mail address is associated with more than one slice.

import sys
import resource
import xmlrpclib
from optparse import OptionParser


XMLRPC_LIB = 'https://www.planet-lab.org/PLCAPI/'
XMLRPC_LIB = 'https://www.planet-lab.eu/PLCAPI/'


def create_parser(): # {{{
	usage = 'usage: %prog [--user=LOGIN] --pass=PASS'
	parser = OptionParser(usage=usage)

	parser.add_option('--user',
			dest='user',
			metavar='LOGIN',
			type='str',
			default='italocunha@gmail.com',
			# also italocunha+thlabpl@gmail.com
			help='username to use for login [%default]')

	parser.add_option('--pass',
			dest='passwd',
			metavar='PASS',
			type='str',
			help='password for LOGIN')

	return parser
# }}}


def main():
	resource.setrlimit(resource.RLIMIT_AS, (2147483648, 2147483648))

	parser = create_parser()
	opts, _args = parser.parse_args()
	if opts.passwd is None:
		parser.parse_args(['-h'])

	api_server = xmlrpclib.ServerProxy(XMLRPC_LIB)

	auth = dict()
	auth['Username'] = opts.user
	auth['AuthString'] = opts.passwd
	auth['AuthMethod'] = 'password'

	nodes = api_server.GetNodes(auth)
	for n in nodes:
		print(n['hostname'])


if __name__ == '__main__':
	sys.exit(main())
