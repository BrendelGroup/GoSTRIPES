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

RAWREAD_NB1=`wc -l ${SAMPLE}_raw_R1.fq|cut -d' ' -f1`
RAWREAD_NB1=`awk "BEGIN {printf \"%.0f\", ${RAWREAD_NB1}/4}"`
RAWREAD_NB2=`wc -l ${SAMPLE}_raw_R2.fq|cut -d' ' -f1`
RAWREAD_NB2=`awk "BEGIN {printf \"%.0f\", ${RAWREAD_NB2}/4}"`
if [[ ${RAWREAD_NB1} -ne ${RAWREAD_NB2} ]]; then
	echo "We have a problem: ${RAWREAD_NB1} left reads versus ${RAWREAD_NB2} right reads ..."
	echo "Please fix."
	exit
fi
echo "Number of raw read pairs: ${RAWREAD_NB1}" > ${SAMPLE}.stats

RAWREAD_LGTH1=`awk 'NR==9' FastQC/${SAMPLE}_raw_R1_fastqc/fastqc_data.txt | awk -F" " '{print $3}'`
RAWREAD_LGTH2=`awk 'NR==9' FastQC/${SAMPLE}_raw_R2_fastqc/fastqc_data.txt | awk -F" " '{print $3}'`
echo "Raw read length range (per FastQC report): ${RAWREAD_LGTH1} (left reads), ${RAWREAD_LGTH2} (right reads)" >> ${SAMPLE}.stats

RAWREAD_ML1=`cat ${SAMPLE}_raw_R1.fq | awk '{if(NR%4==2) printf "%.0f\n", length($1)}' > /tmp/${SAMPLE}_readlength1.txt; sort -n /tmp/${SAMPLE}_readlength1.txt | awk ' { a[i++]=$1; } END { printf "%.0f", a[int(i/2)]; }'`
RAWREAD_ML2=`cat ${SAMPLE}_raw_R2.fq | awk '{if(NR%4==2) printf "%.0f\n", length($1)}' > /tmp/${SAMPLE}_readlength2.txt; sort -n /tmp/${SAMPLE}_readlength2.txt | awk ' { a[i++]=$1; } END { printf "%.0f", a[int(i/2)]; }'`
echo "Median length of raw reads: ${RAWREAD_ML1} (left reads), ${RAWREAD_ML2} (right reads)" >> ${SAMPLE}.stats

RAWREAD_SZE1=`awk 'BEGIN{sum=0;}{if(NR%4==2){sum+=length($0);}}END{printf "%.0f", sum;}' ${SAMPLE}_raw_R1.fq`
RAWREAD_SZE2=`awk 'BEGIN{sum=0;}{if(NR%4==2){sum+=length($0);}}END{printf "%.0f", sum;}' ${SAMPLE}_raw_R2.fq`
RAWSAMPLE_SZE=`awk "BEGIN {printf \"%.0f\", ${RAWREAD_SZE1} + ${RAWREAD_SZE2}}"`
echo "Raw read sample size: ${RAWSAMPLE_SZE} bp" >> ${SAMPLE}.stats


CLNREAD_NB1=`wc -l ${SAMPLE}_clean_R1.fq|cut -d' ' -f1`
CLNREAD_NB1=`awk "BEGIN {printf \"%.0f\", ${CLNREAD_NB1}/4}"`
CLNREAD_NB2=`wc -l ${SAMPLE}_clean_R2.fq|cut -d' ' -f1`
CLNREAD_NB2=`awk "BEGIN {printf \"%.0f\", ${CLNREAD_NB2}/4}"`
if [[ ${CLNREAD_NB1} -ne ${CLNREAD_NB2} ]]; then
	echo "We have a problem: ${CLNREAD_NB1} left versus ${CLNREAD_NB2} right cleaned reads ..."
	echo "Please fix (numbers should be equal!)."
	exit
fi
echo "Number of cleaned read pairs: ${CLNREAD_NB1}" >> ${SAMPLE}.stats

CLNREAD_LGTH1=`awk 'NR==9' FastQC/${SAMPLE}_clean_R1_fastqc/fastqc_data.txt | awk -F" " '{print $3}'`
CLNREAD_LGTH2=`awk 'NR==9' FastQC/${SAMPLE}_clean_R2_fastqc/fastqc_data.txt | awk -F" " '{print $3}'`
echo "Trimmed read length range (per FastQC report): ${CLNREAD_LGTH1} (left reads), ${CLNREAD_LGTH2} (right reads)" >> ${SAMPLE}.stats
CLNREAD_ML1=`cat ${SAMPLE}_clean_R1.fq | awk '{if(NR%4==2) printf "%.0f\n", length($1)}' > /tmp/${SAMPLE}_readlength1.txt; sort -n /tmp/${SAMPLE}_readlength1.txt | awk ' { a[i++]=$1; } END { printf "%.0f", a[int(i/2)]; }'`
CLNREAD_ML2=`cat ${SAMPLE}_clean_R2.fq | awk '{if(NR%4==2) printf "%.0f\n", length($1)}' > /tmp/${SAMPLE}_readlength2.txt; sort -n /tmp/${SAMPLE}_readlength2.txt | awk ' { a[i++]=$1; } END { printf "%.0f", a[int(i/2)]; }'`
echo "Median length of trimmed reads: ${CLNREAD_ML1} (left reads), ${CLNREAD_ML2} (right reads)" >> ${SAMPLE}.stats

CLNREAD_SZE1=`awk 'BEGIN{sum=0;}{if(NR%4==2){sum+=length($0);}}END{printf "%.0f", sum;}' ${SAMPLE}_clean_R1.fq`
CLNREAD_SZE2=`awk 'BEGIN{sum=0;}{if(NR%4==2){sum+=length($0);}}END{printf "%.0f", sum;}' ${SAMPLE}_clean_R2.fq`
CLNSAMPLE_SZE=`awk "BEGIN {printf \"%.0f\", ${CLNREAD_SZE1} + ${CLNREAD_SZE2}}"`
echo "Cleaned sample size: ${CLNSAMPLE_SZE} bp" >> ${SAMPLE}.stats
