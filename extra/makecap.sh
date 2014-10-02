#!/bin/bash

if [[ $# -lt 1 ]] ; then echo "usage: $0 <hostlist>" ; exit 1 ; fi ;

hostlist=$1 ;
echo "ssh_options[:username] = \"upmc_ts\"" ;
echo -n "role :nodes" ;
cat $hostlist | awk '{ printf(", \"%s\"", $0); }' ;
echo "" ;
