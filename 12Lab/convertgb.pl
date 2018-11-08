#!/usr/bin/perl -w
use strict;
use Getopt::Long qw(GetOptions);
use Bio::SeqIO;

my $usage = "USAGE: $0 -i [input_file] -f [fasta|embl] –o [output_file]\n";
my $inputfile = "";
my $format = "";
my $outputfile = "";

#makes sure the right number of arguments are used
if (scalar @ARGV != 6){
  print "Incorrect usage.\n$usage";
  exit;
}

#options used when calling this command
GetOptions(
  'i=s' => \$inputfile,
  'f=s' => \$format,
  'o=s' => \$outputfile,
) or die $usage;

# creating SeqIO object to read in
my $seqinput = Bio::SeqIO->new(
    -file => "$inputfile",
);

# creating SeqIO object to write out
my $seqoutput = Bio::SeqIO->new(
    -file => ">$outputfile",
    -format => $format,
);

# writing entry to the output file
while(my $seq = $seqinput->next_seq) {
  $seqoutput->write_seq($seq);
}
