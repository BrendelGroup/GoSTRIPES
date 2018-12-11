#!/bin/bash
#

#GoSTRIPES script sstats-pe.sh
#
# .. to print some basis statics of the raw and processed reads.
#
# Usage: ./sstats-pe.sh <sample label>

SAMPLE=$1

echo "Sample:		${SAMPLE}"
echo ""
echo " Output file will be written to ${SAMPLE}.stats."


### Sample statistics

RAWREAD_NB1=`wc -l ${SAMPLE}_R1noa.fq|cut -d' ' -f1`
RAWREAD_NB1=`awk "BEGIN {printf \"%.0f\", ${RAWREAD_NB1}/4}"`
RAWREAD_NB2=`wc -l ${SAMPLE}_R2noa.fq|cut -d' ' -f1`
RAWREAD_NB2=`awk "BEGIN {printf \"%.0f\", ${RAWREAD_NB2}/4}"`
if [[ ${RAWREAD_NB1} -ne ${RAWREAD_NB2} ]]; then
	echo "We have a problem: ${RAWREAD_NB1} left reads versus ${RAWREAD_NB2} right reads ..."
	echo "Please fix."
	exit
fi
echo "Number of raw read pairs: ${RAWREAD_NB1}" > ${SAMPLE}.stats

RAWREAD_LGTH1=`awk 'NR==9' FastQC/${SAMPLE}_R1noa_fastqc/fastqc_data.txt | awk -F" " '{print $3}'`
RAWREAD_LGTH2=`awk 'NR==9' FastQC/${SAMPLE}_R2noa_fastqc/fastqc_data.txt | awk -F" " '{print $3}'`
echo "Raw read length range (per FastQC report): ${RAWREAD_LGTH1} (left reads), ${RAWREAD_LGTH2} (right reads)" >> ${SAMPLE}.stats

RAWREAD_ML1=`cat ${SAMPLE}_R1noa.fq | awk '{if(NR%4==2) printf "%.0f\n", length($1)}' > /tmp/${SAMPLE}_readlength1.txt; sort -n /tmp/${SAMPLE}_readlength1.txt | awk ' { a[i++]=$1; } END { printf "%.0f", a[int(i/2)]; }'`
RAWREAD_ML2=`cat ${SAMPLE}_R2noa.fq | awk '{if(NR%4==2) printf "%.0f\n", length($1)}' > /tmp/${SAMPLE}_readlength2.txt; sort -n /tmp/${SAMPLE}_readlength2.txt | awk ' { a[i++]=$1; } END { printf "%.0f", a[int(i/2)]; }'`
echo "Median length of raw reads: ${RAWREAD_ML1} (left reads), ${RAWREAD_ML2} (right reads)" >> ${SAMPLE}.stats

RAWREAD_SZE1=`awk 'BEGIN{sum=0;}{if(NR%4==2){sum+=length($0);}}END{printf "%.0f", sum;}' ${SAMPLE}_R1noa.fq`
RAWREAD_SZE2=`awk 'BEGIN{sum=0;}{if(NR%4==2){sum+=length($0);}}END{printf "%.0f", sum;}' ${SAMPLE}_R2noa.fq`
RAWSAMPLE_SZE=`awk "BEGIN {printf \"%.0f\", ${RAWREAD_SZE1} + ${RAWREAD_SZE2}}"`
echo "Raw read sample size: ${RAWSAMPLE_SZE} bp" >> ${SAMPLE}.stats


TRMREAD_NB1=`wc -l ${SAMPLE}_tagdusted_READ1.fq|cut -d' ' -f1`
TRMREAD_NB1=`awk "BEGIN {printf \"%.0f\", ${TRMREAD_NB1}/4}"`
TRMREAD_NB2=`wc -l ${SAMPLE}_tagdusted_READ2.fq|cut -d' ' -f1`
TRMREAD_NB2=`awk "BEGIN {printf \"%.0f\", ${TRMREAD_NB2}/4}"`
if [[ ${TRMREAD_NB1} -ne ${TRMREAD_NB2} ]]; then
	echo "We have a problem: ${TRMREAD_NB1} left versus ${TRMREAD_NB2} right trimmed (and tagdusted) reads ..."
	echo "Please fix."
	exit
fi
echo "Number of trimmed (and tagdusted) read pairs: ${TRMREAD_NB1}" >> ${SAMPLE}.stats

TRMREAD_LGTH1=`awk 'NR==9' FastQC/${SAMPLE}_tagdusted_READ1_fastqc/fastqc_data.txt | awk -F" " '{print $3}'`
TRMREAD_LGTH2=`awk 'NR==9' FastQC/${SAMPLE}_tagdusted_READ2_fastqc/fastqc_data.txt | awk -F" " '{print $3}'`
echo "Trimmed read length range (per FastQC report): ${TRMREAD_LGTH1} (left reads), ${TRMREAD_LGTH2} (right reads)" >> ${SAMPLE}.stats
TRMREAD_ML1=`cat ${SAMPLE}_tagdusted_READ1.fq | awk '{if(NR%4==2) printf "%.0f\n", length($1)}' > /tmp/${SAMPLE}_readlength1.txt; sort -n /tmp/${SAMPLE}_readlength1.txt | awk ' { a[i++]=$1; } END { printf "%.0f", a[int(i/2)]; }'`
TRMREAD_ML2=`cat ${SAMPLE}_tagdusted_READ2.fq | awk '{if(NR%4==2) printf "%.0f\n", length($1)}' > /tmp/${SAMPLE}_readlength2.txt; sort -n /tmp/${SAMPLE}_readlength2.txt | awk ' { a[i++]=$1; } END { printf "%.0f", a[int(i/2)]; }'`
echo "Median length of trimmed reads: ${TRMREAD_ML1} (left reads), ${TRMREAD_ML2} (right reads)" >> ${SAMPLE}.stats

TRMREAD_SZE1=`awk 'BEGIN{sum=0;}{if(NR%4==2){sum+=length($0);}}END{printf "%.0f", sum;}' ${SAMPLE}_tagdusted_READ1.fq`
TRMREAD_SZE2=`awk 'BEGIN{sum=0;}{if(NR%4==2){sum+=length($0);}}END{printf "%.0f", sum;}' ${SAMPLE}_tagdusted_READ2.fq`
TRMSAMPLE_SZE=`awk "BEGIN {printf \"%.0f\", ${TRMREAD_SZE1} + ${TRMREAD_SZE2}}"`
echo "Trimmed sample size: ${TRMSAMPLE_SZE} bp" >> ${SAMPLE}.stats
