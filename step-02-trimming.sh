#!/bin/sh
#$ -S /bin/sh

# read in input from command line
# parameter file
PARFILE=$1
source ./$PARFILE

# raw fastq
FULLRAWFASTQ=$2

# output directory
TRIMMINGOUT=$3
mkdir -p -m 777 $TRIMMINGOUT

# working directory
WD=`pwd`

# get needed file names
FASTQ=`basename $FULLRAWFASTQ`
BASEN=${FASTQ%.*}

# generate symbol link
ln -sf "../"$FULLRAWFASTQ $TRIMMINGOUT"/"$FASTQ


OUT=$TRIMMINGOUT"/clean-"$BASEN # $TRIMMINGOUT"/clean-"$BASEN".fastq"


HELPERPATH=$OUT

echo $HELPERPATH > $AD/env_var1.txt


java -jar $TRIMMOJAR $READ -threads $THREADS $FULLRAWFASTQ $OUT $ADAPTER $LEADING $HEADCROP $TRAILING $SLIDINGWINDOW $MINLEN


if [ $CLEANUP != 0 ]; then
	rm -f $FASTQ
fi
