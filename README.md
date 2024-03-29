# GoSTRIPES: Computational workflows for STRIPE-seq data analyses

The GoSTRIPES repository encompasses code and scripts developed in the
[Brendel](http://brendelgroup.org/) and [Zentner](http://zentnerlab.bio.indiana.edu/)
groups for analyses of STRIPE-seq data.
The code conforms to our [RAMOSE](https://brendelgroup.github.io/)
philosophy: it generates __reproducible__, __accurate__, and __meaningful__
results; it is __open__ (source) and designed to be __scalable__ and
__easy__ to use.


## Quick Start

All the GoSTRIPES dependencies are encapsulated in a
[Singularity](https://apptainer.org/) container available from our
[Singularity Hub](http://BrendelGroup.org/SingularityHub/).
Thus, once you know what you are doing, execution could be as simple as

```
singularity pull https://BrendelGroup.org/SingularityHub/GoSTRIPES.sif
singularity exec GoSTRIPES.sif make
```

(assuming you have prepared a suitable makefile in your working directory).
If you want to just run particular programs pre-installed in the container,
take a look at [xworkStripes](./bin/xworkStripes).
That script sets up a variable _rws_ ("run with singularity") in your working
shell, which allows you to run commands like the following:

```
$rws fastq-interleave
```

where _fastq-interleave_ is just one of many programs pre-installed in the
container. Please see the [HOWTO](./HOWTO.md) document for a worked example.


## Reference

__Robert A. Policastro, R. Taylor Raborn, Volker P. Brendel and Gabriel E. Zentner (2020)__
 _Simple and efficient profiling of transcription initiation and transcript levels with STRIPE-seq._
Genome Research 30, 910--823. [https://genome.cshlp.org/content/30/6/910.long](https://genome.cshlp.org/content/30/6/910.long).

Original pre-print: [at BioRxiv](https://www.biorxiv.org/content/10.1101/2020.01.16.905182v1).


## Contact

Please direct all comments and suggestions to
[Volker Brendel](<mailto:vbrendel@indiana.edu>)
at [Indiana University](http://brendelgroup.org/).
