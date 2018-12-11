# GoSTRIPES HOWTO - an example for how to use the software

## Preparation

Fortunately, almost nothing is required! More or less, all you need to do is
to pick a directory where you want to install GoSTRIPES and another directory
in which you want to work. We'll assume for this demo that you want to install
GoSTRIPES in your home directory and that you will be working in a directory
called /scratch/AWESOME:

```bash
cd
git clone https://githup.com/GoSTRIPES
cd /scratch/AWESOME
```

Now you can run the [xsetup](./data/xsetup) from the _data_ directory, and
you'll be good to go:

```bash
~/GoSTRIPES/data/xsetup
```

The script will display progress and instructions, so please be sure to read
the text. Importantly, the script will ask you to execute something like the
following in your shell (just copy/paste what the script shows):

```bash
source ~/GoSTRIPES/bin/xworkStripes -b /scratch/AWESOME -i /scratch/AWESOME/STRIPES/gostripes.simg
```

This command will set up the variabl _rws_. In our example,

```bash
echo $rws
```
should return 

```bash
singularity exec -B /scratch/AWESOME /scratch/AWESOME/STRIPES/gostripes.simg
```

Unless something odd happened, you should now be able to run the demo as
follows:

```bash
cd STRIPES/SAMPLE
$rws make
```

_$rws <command>_ will execute any _<command>_ within the GoSTRIPES container.
In our workflow, _make_ will execute the provided Makefile, which takes care
of everything else. Because all required programs and scripts are bundled in
the container, there is nothing else for you to do in terms of installation.
