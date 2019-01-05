#!/usr/bin/perl -w
#
# selectAdapterTrimmedReads.pl
# Version of Jaunuary 5, 2019.  Volker Brendel

use strict;
use Getopt::Std;


my $USAGE="\nUsage: $0 -f read1file -t trimmedread1file -r read2file -o outfilename

** This script compares read1file and trimmedread1file fastq input files and
   selects read1file entries that have been 5' adapter trimmed (as shown in
   trimmedread1file). Output are interleaved fastq files trm-outfilename.fastq and
   unt-outfilename.fastq, which show  the trimmed and untrimmed reads, respectively,
   in each case paired with the correspond read2file records. 

   Stdout shows the trimmed sequences and remainders for all trimmed read1file
   entries.
   \n";


my %args;
getopts('f:t:r:o:', \%args);

my ($read1file,$trim1file,$read2file,$outfile);
my ($FHINFR1,$FHINFT1,$FHINFR2);
my ($FHOUTT,$FHOUTU);

if (!defined($args{f})) {
  print "\nPlease specify a read 1 input file.\n\n";
  die $USAGE;
}
else {
  $read1file = $args{f};
  if (! -e $read1file) {
    print "\nRead file $read1file does not exist.\n\n";
    die $USAGE;
  }
}
if (!defined($args{t})) {
  print "\nPlease specify a trimmed read 1 input file.\n\n";
  die $USAGE;
}
else {
  $trim1file = $args{t};
  if (! -e $trim1file) {
    print "\nRead file $trim1file does not exist.\n\n";
    die $USAGE;
  }
}
if (!defined($args{r})) {
  print "\nPlease specify a read 2 input file.\n\n";
  die $USAGE;
}
else {
  $read2file = $args{r};
  if (! -e $read2file) {
    print "\nRead file $read2file does not exist.\n\n";
    die $USAGE;
  }
}
if (!defined($args{o})) {
  print "\nPlease specify the output file label.\n\n";
  die $USAGE;
}
else {
  $outfile = $args{o};
}

open FHINFR1,  "<$read1file" || die ("Cannot open file: $read1file"); 
open FHINFT1,  "<$trim1file" || die ("Cannot open file: $trim1file"); 
open FHINFR2,  "<$read2file" || die ("Cannot open file: $read2file"); 

open FHOUTT,  ">trm_$outfile.fastq" || die ("Cannot open file: trm_$outfile.fastq"); 
open FHOUTU,  ">unt_$outfile.fastq" || die ("Cannot open file: unt_$outfile.fastq"); 

my $line1r1     = "";
my $line2r1     = "";
my $line3r1     = "";
my $line4r1     = "";
my $line1t1     = "";
my $line2t1     = "";
my $line3t1     = "";
my $line4t1     = "";
my $line1r2     = "";
my $line2r2     = "";
my $line3r2     = "";
my $line4r2     = "";

my $readstotal = 0;
my $readstrimmed = 0;
my $readsuntrimmed = 0;

while (defined($line1r1=<FHINFR1>)) {
  if ($line1r1 =~ /^@/) {
    defined($line2r1=<FHINFR1>) || die ("trouble");
    defined($line3r1=<FHINFR1>) || die ("trouble");
    defined($line4r1=<FHINFR1>) || die ("trouble");

    defined($line1t1=<FHINFT1>) || die ("trouble");
    defined($line2t1=<FHINFT1>) || die ("trouble");
    defined($line3t1=<FHINFT1>) || die ("trouble");
    defined($line4t1=<FHINFT1>) || die ("trouble");

    defined($line1r2=<FHINFR2>) || die ("trouble");
    defined($line2r2=<FHINFR2>) || die ("trouble");
    defined($line3r2=<FHINFR2>) || die ("trouble");
    defined($line4r2=<FHINFR2>) || die ("trouble");
    $readstotal++;

    if ((my $t = substr($line2r1,0,index($line2r1,$line2t1))) ne "") {
      print $t, "\t", substr(($line2t1),0,length($line2t1)-1), "\t", $line1r1;
      print FHOUTT $line1t1;
      print FHOUTT $line2t1;
      print FHOUTT $line3t1;
      print FHOUTT $line4t1;
      print FHOUTT $line1r2;
      print FHOUTT $line2r2;
      print FHOUTT $line3r2;
      print FHOUTT $line4r2;
      $readstrimmed++;
    }
    else {
      print FHOUTU $line1r1;
      print FHOUTU $line2r1;
      print FHOUTU $line3r1;
      print FHOUTU $line4r1;
      print FHOUTU $line1r2;
      print FHOUTU $line2r2;
      print FHOUTU $line3r2;
      print FHOUTU $line4r2;
      $readsuntrimmed++;
    }
  }
  else {
    print "should not happen";
  }
}

printf ("\n\nTotal reads checked: %10d\n\n", $readstotal);
printf ("Reads trimmed       : %10d (%6.2f%%)\n", $readstrimmed,  100*$readstrimmed/$readstotal);
printf ("Reads untrimmed     : %10d (%6.2f%%)\n", $readsuntrimmed,  100*$readsuntrimmed/$readstotal);
