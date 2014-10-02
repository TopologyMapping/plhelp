#!/bin/bash

if [[ $# != 2 ]] ; then
	echo "usage: $0 <nodelist> <progname>" ;
   	exit 1 ;
fi ;

nodelist=$1 ;
progname=$2 ;

BASECMD="vxargs -pr -t 20 -a $nodelist -y" ;

$BASECMD -o out/test/ ssh upmc_ts@{} pgrep $progname ;

up=0 ;
down=0 ;

for file in $( ls out/test/*.out ) ; do
	if [[ -s $file ]] ; then up=$(( $up + 1 )) ; 
	else down=$(( $down + 1 )) ; fi ;
done ;

echo "$up running, $down NOT running." ;
