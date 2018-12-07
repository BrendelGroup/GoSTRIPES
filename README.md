# GoSTRIPES: Computational workflows for STRIPE-seq data analyses

The GoSTRIPES repository encompasses code and scripts developed in the
[Brendel](http://brendelgroup.org/) and [Zentner](http://zentnerlab.bio.indiana.edu/)
groups for analyses of STRIPE-seq data.
The code conforms to our [RAMOSE](https://brendelgroup.github.io/)
philosophy: it generates __reproducible__, __accurate__, and __meaningful__
results; it is __open__ (source) and designed to be __scalable__ and
__easy__ to use.


## Quick Start [![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/1990)

All the GoSTRIPE dependencies are encapsulated in a
[Singularity](https://www.sylabs.io/docs/) container available from
[Singularity Hub](https://singularity-hub.org/).
Thus, once you know what you are doing, execution could be as simple as

```
singularity pull --name gostripes.simg shub://BrendelGroup/GoSTRIPES
singularity exec gostripes.simg make
```

(assuming you have prepared a suitable makefile in your working directory).
If you want to just run particular programs pre-installed in the container,
take a look at [xworkStripes](../bin/xworkStripes).
That scripts set up a variable _rws_ ("run with singularity") in your working shell,
which allows you to run commands like the following:

```
$rws fastq-interleave
```

where _fastq-interleave_ is just one of many programs pre-installed in the container.


## Reference

Robert A. Policastro, R. Taylor Raborn, Volker P. Brendel, and Gabriel E. Zentner
(2019) _Simple and efficient mapping of transcription start sites with STRIPE-seq._
To be submitted.


## Contact

Please direct all comments and suggestions to
[Volker Brendel](<mailto:vbrendel@indiana.edu>)
at [Indiana University](http://brendelgroup.org/).
