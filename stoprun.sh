#!/bin/sh
set -eu

LOGDIR="out/" ;

usage () { # {{{
	cat <<-USAGE
usage: $0 -i NODELIST -l SLICE [-t TIMEOUT]

will call plpt stop in each node in NODELIST. assumes deployment files
were copied in advance (e.g., with copy.sh). SLICE should be a planetlab slice
name (e.g., upmc_ts). TIMEOUT defaults to 30 seconds.
	USAGE
	exit 1
} # }}}

nodelist=invalid
slice=invalid
timeout=30

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

test $nodelist != invalid || usage
test $slice != invalid || usage

vxargs -pry -t $timeout -a $nodelist -o $LOGDIR/stop/ \
		ssh $slice@{} sudo /home/$slice/plpt stop
vxargs -pry -t $timeout -a $nodelist -o $LOGDIR/stop/ \
		ssh $slice@{} sudo /etc/init.d/plpt stop

vxargs -pry -t $timeout -a $nodelist -o $LOGDIR/stop/ \
		ssh $slice@{} sudo killall -9 parisloop
vxargs -pry -t $timeout -a $nodelist -o $LOGDIR/stop/ \
		ssh $slice@{} sudo pkill -9 parisloop
vxargs -pry -t $timeout -a $nodelist -o $LOGDIR/stop/ \
		ssh $slice@{} sudo killall -9 paristr
vxargs -pry -t $timeout -a $nodelist -o $LOGDIR/stop/ \
		ssh $slice@{} sudo pkill -9 paristr
