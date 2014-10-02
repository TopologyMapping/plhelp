#!/bin/bash

if [[ $# -lt 1 ]] ; then
	echo "usage: $0 <pl-node-list>" ;
	exit 1 ;
fi ;

die () {
	echo $1
	exit 1
}

nodelist=$1 ;
BASECMD="vxargs -pr -a $nodelist -y" ;
LOCALDIR="$(pwd)/../datadownload/tomo/" ;

mkdir -p $LOCALDIR ;

$BASECMD -t 360 -o out/dlgz/ mkdir -p $LOCALDIR/{} ;
$BASECMD -P 10 -t 7200 -o out/dlgz/ rsync -auvz --append --exclude '*log.txt' --rsh=ssh upmc_ts@{}:/home/upmc_ts/output/ $LOCALDIR/{}/

