BASEDIR=/home/thomsonple_ts
PARISTR_PATH=$BASEDIR/paristr
CTRACK_PATH=$BASEDIR/ctrack
RNDLINES_PATH=$BASEDIR/randomlines.py

DST_FILE_GZ=$BASEDIR/mit.reach.txt.gz
DST_FILE=$BASEDIR/dst.txt

NUM_DESTINATIONS=1000

# terminating slash below is important: dtrack creates file names by appending
# data to the end of the output prefix.
CTRACK_OUTDIR=$BASEDIR/output/ctrack/
CTRACK_PROBING_RATE=16
CTRACK_MIN_PROBE_PERIOD=15
CTRACK_MAX_PROBE_PERIOD=600
CTRACK_PROBING_RATE_DUMP_PERIOD=300
NN4_DATA_GZ=dmap.t1.m1000.a6.d2419200.k604800.c200000.w86400.n10.cnt1800.preproc.gz
NN4_DATA=dmap.t1.m1000.a6.d2419200.k604800.c200000.w86400.n10.cnt1800.preproc
NN4_DATA_HORIZON=1800
