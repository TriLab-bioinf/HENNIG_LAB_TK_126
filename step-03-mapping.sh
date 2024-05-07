#!/bin/sh
#$ -S /bin/sh

set -e

# read in input from command line
# parameter file
PARFILE=$1
source ./$PARFILE

# trimmed fastq
FULLFASTQF=$2

# output directory
MAPDIR=$3
mkdir -p -m 777 $MAPDIR


# working directory
WD=`pwd`


FASTQF=`basename $FULLFASTQF`
BASEN=${FASTQF%.*}

mkdir -p -m 777 $MAPDIR"/"$BASEN

# mk link
ln -sf "../../"$FULLFASTQF $MAPDIR"/"$BASEN"/"$FASTQF


cd $MAPDIR"/"$BASEN
echo $MAPDIR"/"$BASEN

STAR_OUT_B=$BASEN
STAR_OUT_SORT=$BASEN"_sorted"

INPUT="/data/COVID19-RNAseq/RNA-seq/GSE93847-N642H"/$FULLFASTQF

WP=`pwd`


MAPPINGOUT=$WP"/"$STAR_OUT_SORT".bam"
echo $MAPPINGOUT > $AD/env_var2.txt

cd $WP \
	&& STAR \
	--genomeDir /fdb/STAR_current/UCSC/mm10/genes-50 \
	--sjdbOverhang 50 \
	--readFilesIn $INPUT \
	--outSAMtype BAM SortedByCoordinate \
	--outFilterMultimapNmax 20 \
	--outReadsUnmapped Fastx \
	--runThreadN $STARTHR \
	--outFileNamePrefix $STAR_OUT_B  > $BASEN"_star_$$.log" 2>&1


java -Xmx40g -jar $PICARDJARPATH/picard.jar SortSam INPUT=$STAR_OUT_B"Aligned.sortedByCoord.out.bam" \
			OUTPUT=$STAR_OUT_SORT".bam" SORT_ORDER=coordinate

$SAMTOOLS index $STAR_OUT_SORT".bam"




if [ $CLEANUP != 0 ]; then
	rm -f $FASTQF
	rm -f $STAR_OUT_B
	rm -f $STAR_OUT_B"Aligned.sortedByCoord.out.bam"
fi

