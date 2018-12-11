# Makefile_GoSTRIPES
#
# Version: December 11, 2018.
#

# Note that it is assumed that all required executables are in your $PATH.
# If you are using Singularity to run the GoSTRIPES workflow, then this is
# taken care of. Otherwise, refer to the Singularity recipe on how to set up
# a proper GoSTRIPES environment.

# Typical customization should only involve filling in the variables in the
# next section.

################################################################################
####################### ! Variable Settings ! ##################################
################################################################################

# This template Makefile is ready to run the demo described on the GoSTRIPES
# repository site. To run your own data, you should edit the RAWREAD* variables
# to point to data source and optionally adjust other parameters to fit your
# system and preferences.

RAWREAD1 = downloads/SAMPLE_R1.fastq
RAWREAD2 = downloads/SAMPLE_R2.fastq

UMI     = NNNNNNNN
ADAPTER = TATAGGG
PATTERN = ${UMI}${ADAPTER}
SAMPLE  = demo

# Genome file locations:

BASEDIR     = ..
GENOME_DIR  = ScGENOME
GENOME_FILE = GCF_000146045.2_R64_genomic.fna
GENOME_GFF  = GCF_000146045.2_R64_genomic.gff
RNAfile     = ${BASEDIR}/${GENOME_DIR}/Sc_grRNA.fa


# Options for programs called in the GoSTRIPES workflow:
#
FASTQC_OPTIONS        = --threads 2  --extract
SAMTOOLS_SORT_OPTIONS = -m 7G -@ 4
SORT_BUFFER_SIZE      = 20G

TrueSeq2SE            = /opt/Trimmomatic-0.38/adapters/TruSeq2-SE.fa
THREADS               = 6


################################################################################
### ! Typically there would be no need for further editing below this line ! ###
################################################################################


all:	setup STARdir/${GENOME_DIR} \
	select_${SAMPLE}_R1.fq ${SAMPLE}_R1umi.fq ${SAMPLE}_R1noa.fq ${SAMPLE}_R1trm.fq \
 	select_${SAMPLE}_R2.fq ${SAMPLE}_R2umi.fq ${SAMPLE}_R2noa.fq ${SAMPLE}_R2trm.fq \
	${SAMPLE}_tagdusted_READ1.fq ${SAMPLE}_tagdusted_READ2.fq \
	fastqc1 fastqc2 ${SAMPLE}.stats \
	STARdir/${GENOME_DIR}/SAindex STARdir/${SAMPLE}_STAR_Aligned.sortedByCoord.out.bam \
	${SAMPLE}_proper.bam alignments/${SAMPLE}.bam alignments/${SAMPLE}.sam

.PHONY:	

setup:
ifeq ("$(wildcard ./FastQC)","")
	mkdir FastQC
endif


### Getting reads matching the specified PATTERN and removing the tag sequences.
#
select_%_R1.fq select_%_R2.fq:	${RAWREAD1} ${RAWREAD2}
	fastq-interleave ${RAWREAD1} ${RAWREAD2} > tmp_${SAMPLE}_R1R2.fq
	selectReadsByPattern.pl -m ${PATTERN} -p -o select_${SAMPLE} -r tmp_${SAMPLE}_R1R2.fq

%_R1umi.fq %_R2umi.fq:	select_%_R1.fq select_%_R2.fq
	umi_tools extract -I select_$*_R1.fq -p ${UMI} --read2-in=select_$*_R2.fq -S $*_R1umi.fq --read2-out=$*_R2umi.fq

%_R1noa.fq %_R2noa.fq:	%_R1umi.fq %_R2umi.fq
	cutadapt -j ${THREADS} -g ^${ADAPTER} -e 0 -o $*_R1noa.fq -p $*_R2noa.fq  $*_R1umi.fq $*_R2umi.fq


### Run FastQC to check the quality of the selected reads.
#
fastqc1:	FastQC/$(SAMPLE)_R1noa_fastqc/fastqc_data.txt FastQC/$(SAMPLE)_R2noa_fastqc/fastqc_data.txt

FastQC/$(SAMPLE)_R1noa_fastqc/fastqc_data.txt:	$(SAMPLE)_R1noa.fq
	fastqc  $(FASTQC_OPTIONS)  --outdir=FastQC  $(SAMPLE)_R1noa.fq

FastQC/$(SAMPLE)_R2noa_fastqc/fastqc_data.txt:	$(SAMPLE)_R2noa.fq
	fastqc  $(FASTQC_OPTIONS)  --outdir=FastQC  $(SAMPLE)_R2noa.fq


### Trimming the reads and removing reads that match rRNA targets.
#
%_R1trm.fq %_R2trm.fq:	%_R1noa.fq %_R2noa.fq
	java -jar /opt/Trimmomatic-0.38/trimmomatic-0.38.jar PE \
	-threads 6 \
	$*_R1noa.fq $*_R2noa.fq \
	$*_R1trm.fq $*_unpaired_R1.fq $*_R2trm.fq $*_unpaired_R2.fq \
	ILLUMINACLIP:${TrueSeq2PE}:2:30:10 TRAILING:20 MINLEN:25

%_tagdusted_READ1.fq %_tagdusted_READ2.fq:	%_R1trm.fq %_R2trm.fq
	tagdust -ref ${RNAfile} -dust 97 -t ${THREADS} -fe 3 -1 R:N $*_R1trm.fq $*_R2trm.fq  -o $*_tagdusted


### FastQC again to check the quality of the trimmed and tagdusted reads.
#
fastqc2:	FastQC/$(SAMPLE)_tagdusted_READ1_fastqc/fastqc_data.txt FastQC/$(SAMPLE)_tagdusted_READ2_fastqc/fastqc_data.txt

FastQC/$(SAMPLE)_tagdusted_READ1_fastqc/fastqc_data.txt:	$(SAMPLE)_tagdusted_READ1.fq
	fastqc  $(FASTQC_OPTIONS)  --outdir=FastQC  $(SAMPLE)_tagdusted_READ1.fq

FastQC/$(SAMPLE)_tagdusted_READ2_fastqc/fastqc_data.txt:	$(SAMPLE)_tagdusted_READ2.fq
	fastqc  $(FASTQC_OPTIONS)  --outdir=FastQC  $(SAMPLE)_tagdusted_READ2.fq


### Generate and print basic sample statistics.
#
$(SAMPLE).stats:	$(SAMPLE)_R1noa.fq $(SAMPLE)_R2noa.fq \
			FastQC/$(SAMPLE)_R1noa_fastqc/fastqc_data.txt FastQC/$(SAMPLE)_R2noa_fastqc/fastqc_data.txt \
			$(SAMPLE)_tagdusted_READ1.fq $(SAMPLE)_tagdusted_READ2.fq \
			FastQC/$(SAMPLE)_tagdusted_READ1_fastqc/fastqc_data.txt FastQC/$(SAMPLE)_tagdusted_READ2_fastqc/fastqc_data.txt
	sstats-pe.sh $(SAMPLE)


### STAR alignment.
#
STARdir/${GENOME_DIR}:
ifeq ("$(wildcard ./STARdir)","")
	mkdir STARdir
endif
ifeq ("$(wildcard ./STARdir/${GENOME_DIR})","")
	mkdir STARdir/${GENOME_DIR}
endif

STARdir/${GENOME_DIR}/${GENOME_FILE}:	STARdir/${GENOME_DIR}
ifeq ("$(wildcard ./STARdir/${GENOME_DIR}/${GENOME_FILE})","")
	ln -rs ${BASEDIR}/${GENOME_DIR}/${GENOME_FILE} STARdir/${GENOME_DIR}/${GENOME_FILE}
endif

STARdir/${GENOME_DIR}/SAindex:	STARdir/${GENOME_DIR}/${GENOME_FILE}
	cd STARdir && \
	STAR --runMode genomeGenerate --runThreadN ${THREADS} --genomeDir ${GENOME_DIR} --genomeFastaFiles ${GENOME_DIR}/${GENOME_FILE}

STARdir/${SAMPLE}_STAR_Aligned.sortedByCoord.out.bam:	STARdir/${GENOME_DIR}/SAindex  $(SAMPLE)_tagdusted_READ1.fq $(SAMPLE)_tagdusted_READ2.fq
	cd STARdir && \
	STAR --runMode alignReads --limitBAMsortRAM 19114876484 --runThreadN ${THREADS} \
		--outSAMtype BAM SortedByCoordinate --outSAMorder Paired  --outFileNamePrefix ${SAMPLE}_STAR_ \
		--genomeDir ${GENOME_DIR}  --readFilesIn ../$(SAMPLE)_tagdusted_READ1.fq ../$(SAMPLE)_tagdusted_READ2.fq

${SAMPLE}_proper.bam:	STARdir/${SAMPLE}_STAR_Aligned.sortedByCoord.out.bam
	samtools view -b -f 2 -F 256 -@ ${THREADS} STARdir/${SAMPLE}_STAR_Aligned.sortedByCoord.out.bam > ${SAMPLE}_proper.bam

alignments/${SAMPLE}.bam:	${SAMPLE}_proper.bam
ifeq ("$(wildcard ./alignments)","")
	mkdir alignments
endif
	samtools sort -n ${SAMPLE}_proper.bam | \
	samtools fixmate -r - - | samtools sort - | samtools rmdup - alignments/${SAMPLE}.bam

alignments/${SAMPLE}.sam:	alignments/${SAMPLE}.bam
	samtools view -h alignments/${SAMPLE}.bam > alignments/${SAMPLE}.sam






### Clean up the output directory.
#
cleanup:
	-\mkdir _SCRATCH
	-\mv tmp_${SAMPLE}_R1R2.fq _SCRATCH
	-\mv select_$(SAMPLE)_R*.fq _SCRATCH
	-\mv $(SAMPLE)_R*umi.fq _SCRATCH
	-\mv $(SAMPLE)_R*noa.fq _SCRATCH
	-\mv $(SAMPLE)_unpaired_R*.fq _SCRATCH
	-\mv $(SAMPLE)_R*trm.fq _SCRATCH
	-\mv $(SAMPLE)_tagdusted_un_READ*.fq _SCRATCH
	-\mv $(SAMPLE)_tagdusted_logfile.txt _SCRATCH
	-\mv $(SAMPLE)_proper.bam _SCRATCH

	-\mkdir STORE-$(SAMPLE)
	-\mv $(SAMPLE)_tagdusted_READ*.fq STORE-$(SAMPLE)

### Finish up after cleanup.
#
finishup:
	-\rm -rf _SCRATCH
	zip -r STORE-$(SAMPLE) STORE-$(SAMPLE)
	-\rm -rf STORE-$(SAMPLE)
