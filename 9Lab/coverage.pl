#!/usr/bin/perl -w
use strict;

my $input = $ARGV[0];
my $output = $ARGV[1];

system("gsort -V -k1,3 $input|uniq > sortedinput.bed"); #sorts the input bed file first by column 1, then 2, then 3 and also removes any duplicates.

open (FILE, "sortedinput.bed")
  or die ("Can't open sortedinput.bed");
#initialize variables; 2 copies (i.e. chr and originalchr) are made so that one can be manipulated, and one can be used to compare aginst at the end
my $chr;
my $start;
my $end;
my @chr = ();
my @start = ();
my @end = ();
my $originalchr;
my $originalstart;
my $originalend;
my @originalchr = ();
my @originalstart = ();
my @originalend = ();

while(<FILE>) {
  chomp $_;
  my @columns = split /\t/, $_; #tab is the delimiter
  $chr[@chr] = $columns[0]; #chr column
  $originalchr[@originalchr] = $columns[0];
  $start[@start] = $columns[1]; #start column
  $originalstart[@originalstart] = $columns[1];
  $end[@end] = $columns[2]; #end column
  $originalend[@originalend] = $columns[2];
}
close FILE;

#finding the overlaps
for (my $i = 0; $i < scalar @chr; $i++){
  if ($chr[$i] eq $chr[$i+1]){ #makes sure sets of coordinates compared are on the same chromosome
    if($start[$i+1] le $start[$i] && $end[$i+1] gt $end[$i]){ #if set of coordinates contain another set of coordinates
      $start[$i+1] = $end[$i];
    }
    elsif(($start[$i+1] lt $end[$i]) && ($start[$i+1] gt $start[$i])){ #if set of coordinates are found inside another set of coordinates
      push @chr, $chr[$i]; #adding a new row after computing overlap
      push @start, $start[$i+1];#adding a new row after computing overlap
      push @end, $end[$i];#adding a new row after computing overlap
      my $temp = $start[$i+1]; #temporary variable made to swap 2 variables
      $start[$i+1] = $end[$i]; #swapping $start[$i+1] and $end[$i]
      $end[$i] = $temp;
    }
  }
}

my @coverage = (0)x(scalar @chr); #initializing array of counts for each row
#counting coverage of the coordinates for each row
for (my $j = 0; $j < scalar @chr; $j++){
  for (my $i = 0; $i < scalar @originalchr; $i++){
    if($chr[$j] eq $originalchr[$i]){
      if (($start[$j] ge $originalstart[$i]) && ($end[$j] le $originalend[$i])){
        $coverage[$j]++;
      }
    }
  }
}

for (my $i = 0; $i < scalar @chr; $i++){ #printing similar to UCSC bedGraph track format
  system("echo $chr[$i]\t$start[$i]\t$end[$i]\t$coverage[$i] >> preoutput.txt");
}

system("gsort -V -k1,3 preoutput.txt > $output"); #sorts preoutput.txt file by first 3 columns
system("rm preoutput.txt sortedinput.bed"); #removes temporary files
