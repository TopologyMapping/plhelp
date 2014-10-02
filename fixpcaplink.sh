#!/bin/sh
set -eu ;

LOGDIR="log/" ;

usage () { # {{{
	cat <<-USAGE
usage: $0 -i NODELIST -l SLICE [-t TIMEOUT]

this attempts to fix the /usr/lib/libpcap.so.0 link on PL nodes in NODELIST.
SLICE should be a planetlab slice (e.g., upmc_ts). TIMEOUT defaults to 10.

	USAGE
	exit 1
} # }}}

mkdir -p $LOGDIR

slice=invalid
nodelist=invalid
timeout=20

while getopts "i:l:t:h" OPTNAME ; do # {{{
case $OPTNAME in
i)
	nodelist=$OPTARG
	;;
l)
	slice=$OPTARG
	;;
t)
	timeout=$OPTARG
	;;
h|*)
	usage
	;;
esac
done
shift $(expr $OPTIND - 1)
OPTIND=1 # }}}

test $slice != invalid || usage
test $nodelist != invalid || usage
if [ ! -f $nodelist ] ; then echo "nodelist not found." ; exit 1 ; fi

BASECMD="vxargs -pry -t $timeout -a $nodelist -o $LOGDIR/fixpcaplink/"

cat > remotefix.sh <<PCAPLINK
test -s /usr/lib/libpcap.so.0 && unlink /usr/lib/libpcap.so.0
test -s /usr/lib/libpcap.so.1 && ln -s /usr/lib/libpcap.so.1 /usr/lib/libpcap.so.0 && ln -s /usr/lib/libpcap.so.1 /usr/lib/libpcap.so.0.9 && exit 0
test -s /usr/lib/libpcap.so.0.9 && ln -s /usr/lib/libpcap.so.0.9 /usr/lib/libpcap.so.0 && exit 0
echo "could not find /usr/lib/libpcap.so.{1,0.9}"
PCAPLINK

$BASECMD scp remotefix.sh $slice@{}:/home/$slice/remotefix.sh
$BASECMD ssh $slice@{} sudo bash /home/$slice/remotefix.sh
$BASECMD ssh $slice@{} rm -f /home/$slice/remotefix.sh

rm -f remotefix.sh

$BASECMD ssh $slice@{} ls /usr/lib/libpcap.so.0 > /dev/null
echo "# reporting broken nodes:"
for file in $(ls $LOGDIR/fixpcaplink/*.out) ; do 
	linkname=$(cat $file)
	fn=$(basename $file)
	fn=${fn%.out}
	if [ "$linkname" != "/usr/lib/libpcap.so.0" ] ; then echo $fn ; fi
done
