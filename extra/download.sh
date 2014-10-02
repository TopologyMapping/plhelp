#!/bin/bash

if [[ $# -lt 2 ]] ; then
	echo "usage: $0 <pl-node-list> <filename.gz>" ; exit 1 ; fi ;

nodelist=$1 ;
filename=out.tar.bz2 ;
BASECMD="vxargs -pr -a $nodelist -y" ;
LOCALDIR="$(pwd)/../download/" ;

if [[ -e $LOCALDIR ]] ; then rm -rf $LOCALDIR ; fi ;
mkdir $LOCALDIR ;

$BASECMD -t 360 -o out/dlgz/ mkdir $LOCALDIR/{} ;
rsync -auvz --progress --rsh=ssh $HOME/bin/rsynchome.sh $DEST./bin/ ;



# $BASECMD -P 999 -t 7200 -o out/dlgz/ ssh upmc_ts@{} tar jcf $filename output ;
# $BASECMD -P 10 -t 7200 -o out/dlgz/ scp -qC upmc_ts@{}:$filename $LOCALDIR/{}/ ;

