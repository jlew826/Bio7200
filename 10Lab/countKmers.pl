#!/usr/bin/perl -w
use strict;

#Usage:  ./countKmers.pl <input file name> <length of k-mer>

my $inputfile = $ARGV[0];
my $kmerlen = $ARGV[1]; #saves k-mer length from command line to a variable

open (FILE, $inputfile)
  or die ("Can't open $inputfile\n");

my $lines;
my @lines=();

#inserting all lines of file into array @lines
while(<FILE>) {
  chomp $_;
  $lines[@lines] = $_;
}
close FILE;

my $description = shift @lines; #takes off the first line (description line) from file

my @DNA = ();
my $DNAlen = 0;

#puts each nucleotide into an array @DNA
for (my $i = 0; $i < scalar @lines; $i++){
  foreach my $char (split//,$lines[$i]){
    $DNA[$DNAlen] = $char;
    $DNAlen++;
  }
}

#looks for all k-mers, and puts them into a hash %kmers
my %kmers;
for (my $i = 0; $i < ($DNAlen-$kmerlen+1); $i++){
  my $kmer="";
  for (my $j = 0; $j < $kmerlen; $j++){
    $kmer = $kmer.$DNA[$i+$j];
  }
  $kmers{$kmer} += 1; #counting the occurance of that k-mers
}

#prints k-mers and their occurance in alphabetical order
foreach my $key (sort keys %kmers){
  print "$key $kmers{$key}\n"
}
