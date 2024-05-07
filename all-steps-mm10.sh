#!/bin/sh
#$ -S /bin/sh

set -e

#Analysis directory
AD=`pwd`
export AD


# used moduels
module load fastqc/0.11.9
module load bowtie/1.1.2
module load trimmomatic/0.36
module load samtools/1.9
module load STAR/2.7.11b #2.5.4a
module load htseq/0.9.1
module load picard/2.9.2


# Number of threads
NT=${SLURM_CPUS_PER_TASK}

# Read in the arguments from the command line
# parameter file
PARFILE=$1
source ./$PARFILE
# replace string in parameter file by the number of threads
sed -i "s/NUMBERTHREADS/$NT/g" $PARFILE

INPUTFILE=$2


LOGFILE=$3


while read line
do

	#gunzip $line
	FASTQ_ORG=`basename $line`


	FASTQ=${FASTQ_ORG%.*}
	PWDRAW=`dirname $line`
	SAMPLE=${FASTQ%.*}
	

	echo "#################################"
	echo "### "$SAMPLE
	echo "#################################"



	# FASTQC report
	echo ""
	echo ""
	echo "### FASTQC RAW DATA"
	sh step-01-fastqc.sh $PARFILE $PWDRAW/$FASTQ_ORG 01-fastq-mm10


	# TRIMMING TRIMMOMATIC
	echo ""
	echo ""
	echo "### TRIMMING"
	sh step-02-trimming.sh $PARFILE $PWDRAW/$FASTQ_ORG 02-trimming-mm10

	while read helper1
	do	 
		TRIMMINGOUT=$helper1
	done < env_var1.txt


	# FASTQC report
	echo ""
	echo ""
	echo "### FASTQC TRIMMED DATA"
	sh step-01-fastqc.sh $PARFILE $TRIMMINGOUT 03_fastqc-mm10


	# MAPPING
	echo ""
	echo ""
	echo "### MAPPING"
	sh step-03-mapping.sh $PARFILE $TRIMMINGOUT 04-mapping-mm10

	while read helper2
	do	 
		MAPPINGOUT=$helper2
	done < env_var2.txt


	FASTQ_UNIQUE=`basename $MAPPINGOUT`
	PWD_MAPPING=`dirname $MAPPINGOUT `


	echo ""
	echo ""
	echo "### HTSEQ"
	sh step-04-htseq.sh $PARFILE $MAPPINGOUT 05-htseq-mm10


	# ZIP FASTQ FILE
	#echo ""
	#echo "zipping FASTQ files..."
	#echo "### "$SAMPLE

	#gzip $TRIMMINGOUT
 	#gzip $PWDRAW/$SAMPLE".fastq"


	if [ $CLEANUP != 0 ];
	 	then
		rm -f env_var1.txt
		rm -f env_var2.txt
	fi
# 2>&1 2 is stderr und 1 is stdout, so stderr goes whereever stdout goes 
done < $INPUTFILE > $LOGFILE 2>&1





