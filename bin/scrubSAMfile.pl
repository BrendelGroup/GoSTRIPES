#!/usr/bin/perl -w
#
# scrubSAMfile.pl
# Version of January 5, 2019.  Volker Brendel

use strict;
use Getopt::Std;


my $USAGE="\nUsage: $0 [-s max_nbrS] [-i min_intronlength] [-I max_intronlength]
                         [-t max_TLEN] [-o outfile] -r SAMfile\

** This script selects read pairs from a paired, name-sorted SAM inputf file by the
   following criteria:
     - reads must be paired
     - the mappings should not include read1 5' soft-clipping longer than max_nbrS
     - the mappings should not allow within-read gaps longer than max_intronlength
     - the SAM TLEN value should not exceed max_TLEN

   Take a look at the output files (columns 2, 6, and 9), and all shall be revealed.
   \n";


my %args;
getopts('s:i:I:t:o:r:', \%args);

my ($SAMfile,$outputfile,$outputfile1,$outputfile2,$outputfile3,
             $outputfile4,$outputfile5,$outputfile6);
my $max_nbrS         =    3;
my $min_intronlength =   50;
my $max_intronlength = 1000;
my $max_TLEN         = 1500;
my ($FHINF,$FHOUTF);

if (!defined($args{r})) {
  print "\nPlease specify a paired, name-sorted SAM input file.\n\n";
  die $USAGE;
}
else {
  $SAMfile = $args{r};
  if (! -e $SAMfile) {
    print "\nSAM file $SAMfile does not exist.\n\n";
    die $USAGE;
  }
}

if (defined($args{s})) {
  $max_nbrS = $args{s};
}
print "\nMaximal soft-clipping length set to :\t$max_nbrS";
if (defined($args{i})) {
  $min_intronlength = $args{i};
}
print "\nMinimal 'intron' size set to        :\t$min_intronlength";
if (defined($args{I})) {
  $max_intronlength = $args{I};
}
print "\nMaximal 'intron' size set to        :\t$max_intronlength";
if (defined($args{t})) {
  $max_TLEN = $args{t};
}
print "\nMaximal TLEN (column 9 value) set to:\t$max_TLEN\n";

if (!defined($args{o})) {
  $outputfile = $SAMfile;
}
else {
  $outputfile = $args{o};
}


open FHINF,  "<$SAMfile" || die ("Cannot open file: $SAMfile"); 
$outputfile1 = "Singlets-" .$outputfile;
open FHOUTF1,  ">$outputfile1" || die ("Cannot open file: $outputfile1"); 
$outputfile2 = "TooSoft-" . $outputfile;
open FHOUTF2,  ">$outputfile2" || die ("Cannot open file: $outputfile2"); 
$outputfile3 = "LongGaps-" . $outputfile;
open FHOUTF3,  ">$outputfile3" || die ("Cannot open file: $outputfile3"); 
$outputfile4 = "LongTLEN-" . $outputfile;
open FHOUTF4,  ">$outputfile4" || die ("Cannot open file: $outputfile4"); 
$outputfile5 = "WithIntrons-" . $outputfile;
open FHOUTF5,  ">$outputfile5" || die ("Cannot open file: $outputfile5"); 
$outputfile6 = "Scrubbed-" . $outputfile;
open FHOUTF6,  ">$outputfile6" || die ("Cannot open file: $outputfile6"); 


my $line1     = "";
my $line2     = "";
my $tmpline   = "";
my @read1vars;
my @read2vars;
my $read1name = "";
my $read2name = "";
my $read1nbrS;
my $read1nbrT;
my $read2nbrS;
my $read2nbrT;
my $read1nbrN;
my $read2nbrN;
my $read1TLEN;
my $read2TLEN;

my $skip = 0;
my $readstotal = 0;
my $singletreads = 0;
my $readsTooSoft = 0;
my $readslonggap = 0;
my $readslongTLEN = 0;
my $readsinclintrons = 0;
my $readsaccepted = 0;
my $readsrejected = 0;

while (defined($line1=<FHINF>)) {
  if ($line1 =~ /^@/) {
    next;
  }
  $readstotal++;
  if ($skip) {
    $tmpline = $line1; $line1 = $line2; $line2 = $tmpline;
  } else {
    defined($line2=<FHINF>) || die ("trouble");
    $readstotal++;
  }
  @read1vars = split('\t',$line1);
  @read2vars = split('\t',$line2);
  ($read1name) = $read1vars[0] =~ m/([^#_\s]+)[#_\s].*/;
  ($read2name) = $read2vars[0] =~ m/([^#_\s]+)[#_\s].*/;
  if ($read1name ne $read2name) {
    print FHOUTF1 $line1;
    $singletreads++;
    $skip = 1;
  } else {
    $skip = 0;
    ($read1nbrS) = $read1vars[5] =~ m/^(\d+)S\d*M/;
    ($read1nbrT) = $read1vars[5] =~ m/\d*M(\d+)S$/;
    ($read2nbrS) = $read2vars[5] =~ m/^(\d+)S\d*M.*/;
    ($read2nbrT) = $read2vars[5] =~ m/\d*M(\d+)S$/;
    ($read1nbrN) = $read1vars[5] =~ m/\d*M(\d+)N.*/;
    ($read2nbrN) = $read2vars[5] =~ m/\d*M(\d+)N.*/;
    $read1TLEN = $read1vars[8];
    $read2TLEN = $read2vars[8];

    if ($read1vars[1] == "99" && (defined($read1nbrS) &&  $read1nbrS > $max_nbrS)  || 
        $read1vars[1] == "83" && (defined($read1nbrT) &&  $read1nbrT > $max_nbrS)  
       ) {
          print FHOUTF2 $line1;
          print FHOUTF2 $line2;
          $readsTooSoft++;
          next;
    }

    if ((defined($read1nbrN) &&  $read1nbrN > $max_intronlength)  || 
        (defined($read2nbrN) &&  $read2nbrN > $max_intronlength)  
       ) {
          print FHOUTF3 $line1;
          print FHOUTF3 $line2;
          $readslonggap++;
          next;
    }
    if (abs($read1TLEN) > $max_TLEN || 
        abs($read2TLEN) > $max_TLEN
       ) {
          print FHOUTF4 $line1;
          print FHOUTF4 $line2;
          $readslongTLEN++;
          next;
    }
    if ((defined($read1nbrN) &&  $read1nbrN >= $min_intronlength)  || 
        (defined($read2nbrN) &&  $read2nbrN >= $min_intronlength)  
       ) {
          print FHOUTF5 $line1;
          print FHOUTF5 $line2;
          $readsinclintrons++;
    }
    print FHOUTF6 $line1;
    print FHOUTF6 $line2;
    $readsaccepted++;
  }
}

$readsrejected = $singletreads + 2*($readsTooSoft + $readslonggap + $readslongTLEN);
printf("\n\nTotal reads checked: %10d\n\n", $readstotal);
printf("Accepted read pairs            : %10d (%6.2f%%)\tfile: %s\n",
	$readsaccepted,  200*$readsaccepted/$readstotal, $outputfile6);
printf("Rejected reads                 : %10d (%6.2f%%)\n",
	$readsrejected,  100*$readsrejected/$readstotal);

printf("\n\n  Rejection categories (#rr = number of reads rejected):\n\n");
printf("  Singlet reads                        : %10d (%6.2f%%) #rr: %10d\tfile: %s\n",
	$singletreads,  100*$singletreads/$readstotal, $singletreads, $outputfile1);
printf("  Read pairs too soft                  : %10d (%6.2f%%) #rr: %10d\tfile: %s\n",
	$readsTooSoft,  200*$readsTooSoft/$readstotal, 2*$readsTooSoft, $outputfile2);
printf("  Read pairs with long within-read gaps: %10d (%6.2f%%) #rr: %10d\tfile: %s\n",
	$readslonggap,  200*$readslonggap/$readstotal, 2*$readslonggap, $outputfile3);
printf("  Read pairs with long TLEN            : %10d (%6.2f%%) #rr: %10d\tfile: %s\n",
	$readslongTLEN,  200*$readslongTLEN/$readstotal, 2*$readslongTLEN, $outputfile4);

printf("\n\nAccepted reads with special features:\n\n");
printf("  Read pairs with within-read introns: %10d (%6.2f%%)\tfile: %s\n",
	$readsinclintrons,  200*$readsinclintrons/$readstotal, $outputfile5);
