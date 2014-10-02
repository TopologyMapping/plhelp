#!/bin/sh
set -eu

usage () { # {{{
	cat <<-USAGE
usage: $0 -i NODELIST -o OUTPUT

NODELIST should have one hostname per line.  OUTPUT will have one IP address
per line.  errors are reported on standard output.

	USAGE
	exit 1
} # }}}

input=invalid
output=invalid

while getopts "i:o:" OPTNAME ; do # {{{
case $OPTNAME in
i)
	input=$OPTARG
	;;
o)
	output=$OPTARG
	;;
h|*)
	usage
	;;
esac
done
shift $(expr $OPTIND - 1)
OPTIND=1 # }}}

test $input != invalid || usage
test -e $input || usage
test $output != invalid || usage
test ! -e $output || rm $output

for hostname in $(cat $input) ; do
	ip=$(host -4 -t A $hostname | grep "has address" | cut -d " " -f 4)
	if [ $? -ne 0 ] ; then
		echo "[$hostname] $ip" ;
		echo "" >> $output ;
		continue ;
	fi ;
	echo $ip >> $output ;
done ;
