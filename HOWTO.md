# GoSTRIPES HOWTO - an example for how to use the software

## Preparation

Fortunately, almost nothing is required! More or less, all you need to do is
to pick a directory where you want to install GoSTRIPES and another directory
in which you want to work. We'll assume for this demo that you want to install
GoSTRIPES in your home directory and that you will be working in a directory
called /scratch/TRYgoSTRIPES:

```bash
cd
git clone https://githup.com/GoSTRIPES
cd /scratch/TRYgoSTRIPES
```

Now you can run the [xsetup_Sc](./data/xsetup_SC) from the _templates_
directory, and you'll be good to go:

```bash
~/GoSTRIPES/templates/xsetup_Sc
```

The script will display progress and instructions, so please be sure to read
the text. Importantly, the script will ask you to execute something like the
following in your shell (just copy/paste what the script shows):

```bash
source ~/GoSTRIPES/bin/xworkStripes -b /scratch/TRYgoSTRIPES -i /scratch/TRYgoSTRIPES/STRIPES/gostripes.simg
```

This command will set up the variable _rws_. In our example,

```bash
echo $rws
```
should return 

```bash
singularity exec -B /scratch/TRYgoSTRIPES /scratch/TRYgoSTRIPES/STRIPES/gostripes.simg
```

## Executing the workflow

Unless something odd happened, you should now be able to review and run the demo
as follows:

```bash
cd STRIPES
~/GoSTRIPES/templates/xsetup_samples
cd demo_s_mock
$rws make -n
$rws make
```

_$rws \<command\>_ will execute any _\<command\>_ within the GoSTRIPES
container. In our workflow, _make_ will invoke the provided Makefile, which
takes care of everything else. Because all required programs and scripts are
bundled in the container, there is nothing else for you to do in terms of
installation.

Note: Typically, you will have multiple samples to analyze. The file
_samples.tsv_ is used to record all the samples (for this demo there is only one
sample). To run all the samples, you can run the following commands, in the
_STRIPES_ directory, following the _xsetup\_samples_ step:

```bash
${installdir}/templates/xrun_samples
${installdir}/templates/xcleanup_samples
```

This will generate all the alignment files and record the results in file
_bamfiles.tsv_, which can be used for input to TSRchitect (see
https://github.com/vpbrendel/TSRchitect/wiki/FAQ).

Note: If the demo fails in your attempts, a fair possibility is that you did not
execute the source '.. xworkStripes ..' command discussed above. Please do that
first!

