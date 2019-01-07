bootstrap: docker
From: ubuntu:18.04

%help
    This container provides portable & reproducible components for GoSTRIPES:
    Workflows for STRIPE-seq data analysis (from Brendel Group).
    Please see https://github.com/BrendelGroup/GoSTRIPES for complete documentation.

%post
    apt -y update
    apt -y install build-essential
    apt -y install bc git tcsh tzdata unzip zip wget
    apt -y install cpanminus
    apt -y install openjdk-8-jdk
    apt -y install software-properties-common
    apt -y install libcairo2-dev
    apt -y install libcurl4-openssl-dev
    apt -y install libcurl4-gnutls-dev
    apt -y install libudunits2-dev
    apt -y install libgd-dev
    apt -y install libmariadb-client-lgpl-dev
    apt -y install libpq-dev
    apt -y install libssl-dev
    apt -y install libtbb-dev
    apt -y install libxml2-dev
    apt -y install python-minimal
    apt -y install python-pip
    apt -y install python3-minimal
    apt -y install python3-pip


### Read quality control

    echo 'Installing FASTQC from http://www.bioinformatics.babraham.ac.uk/projects/fastqc/ '
    #### Install
    cd /opt
    wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip
    unzip fastqc_v0.11.8.zip
    chmod +x FastQC/fastqc

    echo 'Installing TRIM_GALORE from http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/ '
    #### Prerequisites
    pip3 install --upgrade cutadapt
    #### Install
    cd /opt
    wget https://github.com/FelixKrueger/TrimGalore/archive/0.5.0.zip
    mv 0.5.0.zip TrimGalore-0.5.0.zip
    unzip TrimGalore-0.5.0.zip

    echo 'Installing Trimmomatic from http://www.usadellab.org/cms/index.php?page=trimmomatic '
    #### Install
    cd /opt
    wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.38.zip
    unzip Trimmomatic-0.38.zip
#   Use:	java -jar /opt/Trimmomatic-0.38/trimmomatic-0.38.jar

    echo 'Installing TagDust from https://sourceforge.net/projects/tagdust/files/latest/download '
    #### Install
    cd /opt
    wget --content-disposition https://sourceforge.net/projects/tagdust/files/tagdust-2.33.tar.gz/download
    tar -xzf tagdust-2.33.tar.gz 
    cd tagdust-2.33/
    ./configure
    make
    make install


### Read manipulation

    echo 'Installing SRATOOLKIT from http://www.ncbi.nlm.nih.gov/books/NBK158900/ '
    ###### Install
    cd /opt
    wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.9.2/sratoolkit.2.9.2-ubuntu64.tar.gz
    tar -xzf sratoolkit.2.9.2-ubuntu64.tar.gz

    echo 'Installing UMI-tools from https://github.com/CGATOxford/UMI-tools '
    #### Install
    pip install --upgrade umi-tools


### Read mapping

    echo 'Installing bwa from https://github.com/lh3/bwa '
    ###### Install
    cd /opt
    git clone https://github.com/lh3/bwa.git
    cd bwa
    make
    cp bwa /usr/local/bin/

    echo 'Installing BOWTIE2 from http://bowtie-bio.sourceforge.net/bowtie2 '
    ###### Install
    apt -y install bowtie2

    echo 'Installing hisat2 from https://ccb.jhu.edu/software/hisat2/ '
    ###### Install
    cd /opt
    git clone https://github.com/infphilo/hisat2 hisat2
    cd hisat2
    make

    echo 'Installing STAR from https://github.com/alexdobin/STAR '
    ###### Install
    cd /opt
    git clone https://github.com/alexdobin/STAR


### Alignment utilities

    echo 'Installing HTSLIB from http://www.htslib.org/ '
    #### Prerequisites
    apt -y install zlib1g-dev libbz2-dev liblzma-dev
    #### Install
    cd /opt
    git clone git://github.com/samtools/htslib.git htslib
    cd htslib
    make && make install

    echo 'Installing SAMTOOLS from http://www.htslib.org/ '
    #### Prerequisites
    apt -y install ncurses-dev
    #### Install
    cd /opt
    git clone git://github.com/samtools/samtools.git samtools
    cd samtools
    make && make install


### Genome utilities

    echo 'Installing GENOMETOOLS from from http://genometools.org/ '
    #### Prerequisites
    apt -y install libcairo2-dev libpango1.0-dev
    #### Install
    cd /opt
    wget http://genometools.org/pub/genometools-1.5.10.tar.gz
    tar -xzf genometools-1.5.10.tar.gz
    cd genometools-1.5.10/
    make && make install


### All things R

    echo 'Installing R'
    #### 
    export DEBIAN_FRONTEND=noninteractive
    add-apt-repository -y ppa:marutter/rrutter3.5
    add-apt-repository -y ppa:marutter/c2d4u3.5
    apt -y update
    apt -y install r-base-core r-base-dev
    R CMD javareconf

    echo 'Installing CRAN packages'
    ######
    apt -y install r-cran-biocmanager
    apt -y install r-cran-dplyr
    apt -y install r-cran-ggplot2
    apt -y install r-cran-gplots
    apt -y install r-cran-gridextra
    apt -y install r-cran-pastecs
    apt -y install r-cran-rjava
    apt -y install r-cran-sqldf
    apt -y install r-cran-tidyr
    apt -y install r-cran-venneuler
    apt -y install r-cran-rcurl
    apt -y install r-cran-xml2
   
    echo 'Installing other CRAN and Bioconductor packages'
    ######
    echo 'install.packages("R.devices", repos="http://mirror.las.iastate.edu/CRAN/", dependencies=TRUE)'   > R2install
    echo 'BiocManager::install(c("BiocGenerics", "GenomicRanges", "genomation", "TSRchitect"),ask=FALSE)' >> R2install
    echo 'BiocManager::install(c("bumphunter", "seqLogo", "ENCODExplorer", "edgeR"),ask=FALSE)'           >> R2install
    echo 'BiocManager::install(c("ChIPseeker", "ChIPpeakAnno"),ask=FALSE)'                                >> R2install
    echo 'BiocManager::install(c("TxDb.Scerevisiae.UCSC.sacCer3.sgdGene", "org.Sc.sgd.db"),ask=FALSE)'    >> R2install

    Rscript R2install


### Tools to analyze mapped reads

    echo 'Installing RSEM from http://deweylab.github.io/RSEM/ ' 
    #### Install
    cd /opt
    git clone https://github.com/deweylab/RSEM.git
    cd RSEM
    make
    make ebseq
    make install

    echo 'Installing GoSTRIPES from git://github.com/BrendelGroup/GoSTRIPES '
    #### Install
    cd /opt
    git clone git://github.com/BrendelGroup/GoSTRIPES


%environment
    export LC_ALL=C
    export PATH=$PATH:/opt/FastQC
    export PATH=$PATH:/opt/GoSTRIPES/bin
    export PATH=$PATH:/opt/hisat2
    export PATH=$PATH:/opt/sratoolkit.2.8.2-ubuntu64/bin
    export PATH=$PATH:/opt/STAR/bin/Linux_x86_64
    export PATH=$PATH:/opt/TrimGalore-0.5.0

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

%labels
    Maintainer vpbrendel
    Version v1.0
