#!/bin/sh
set -eu ;

LOGDIR="log/" ;

usage () { # {{{
	cat <<-USAGE
usage: $0 -i NODELIST -l SLICE [-t TIMEOUT]

this attempts to fix the sudo command on PL nodes in NODELIST. SLICE
should be a planetlab slice (e.g., upmc_ts). TIMEOUT defaults to 10.

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

BASECMD="vxargs -pry -t $timeout -a $nodelist -o $LOGDIR/fixsudo/"

cat > sudoers.tmp <<SUDOERS
Defaults !requiretty
Defaults !authenticate
Defaults env_reset
Defaults env_keep = "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"
Defaults env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"
Defaults env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"
Defaults env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"
Defaults env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"
Defaults logfile=/var/log/sudo
root	ALL=(ALL) 	ALL
$slice	ALL=(ALL)	ALL
SUDOERS

$BASECMD scp sudoers.tmp $slice@{}:/home/$slice/sudoers
$BASECMD nohup ssh -t -t $slice@{} su -c \'mv /home/$slice/sudoers /etc/sudoers\'
$BASECMD nohup ssh -t -t $slice@{} su -c \'chmod 440 /etc/sudoers\'
$BASECMD nohup ssh -t -t $slice@{} su -c \'chown root:root /etc/sudoers\'
rm -f sudoers.tmp

$BASECMD ssh $slice@{} sudo hostname > /dev/null
echo "# reporting broken nodes:"
for file in $(ls $LOGDIR/fixsudo/*.out) ; do 
	name=$(cat $file)
	fn=$(basename $file)
	fn=${fn%.out}
	if [ "$name" != "$fn" ] ; then echo $fn ; fi
done
