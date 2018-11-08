#!/usr/bin/perl -w
use strict;

#Write a script to summarize an input BED file (download the UCSC gene table
#from the Table Browser in BED format as you did for Week 5; it should include
#at least the strand information along with the chr, start and stop), the name
#of which you will take from the command line.

open (FILE, "<$ARGV[0]")
  or die ("Can't open $ARGV[0]");

my $start;
my $end;
my $strand;
my @start=();
my @end=();
my @strand=();

while(<FILE>) {
  chomp $_;
  my @columns = split /\t/, $_; #tab is the delimiter
  $start[@start] = $columns[1]; #start of each entry
  $end[@end] = $columns[2]; #end of each entry
  $strand[@strand] = $columns[5]; #strand of each entry (+ or -)
}
close FILE;

#total entries
print "Total number of entries: ".scalar @start."\n";

#total length of entries
my $sum = 0; #initalize $sum to 0
for (my $i = 0; $i < (scalar @start); $i++){
  $sum += ($end[$i]-$start[$i]); #add length of every entry
}
print "Total length of entries: $sum\n";

#total entries on + strand
my $posstrand = 0;
for (my $i = 0; $i < (scalar @start); $i++){
  if($strand[$i] eq "+"){
    $posstrand++; #adds 1 every time the entry strand is "+"
  }
}
print "Number of entries on + strand: $posstrand\n";

#total entries on - strand
my $negstrand = 0;
for (my $i = 0; $i < (scalar @start); $i++){
  if($strand[$i] eq "-"){
    $negstrand++; #adds 1 every time the entry strand is "-"
  }
}
print "Number of entries on - strand: $negstrand\n";

#longest entry
my $longest = 0; #initially setting longest entry as 0
for (my $i = 0; $i < (scalar @start); $i++){
  if(($end[$i]-$start[$i]) > $longest){ #if entry length is longer than current $longest, it becomes the new $longest
    $longest = ($end[$i]-$start[$i])
  }
}
print "Longest entry: $longest\n";

#shortest entry
my $shortest = ($end[0]-$start[0]); #initially setting shortest entry as first entry
for (my $i = 0; $i < (scalar @start); $i++){
  if(($end[$i]-$start[$i]) < $shortest){ #if entry length is shorter than current $shortest, it becomes the new $shortest
    $shortest = ($end[$i]-$start[$i])
  }
}
print "Shortest entry: $shortest\n";

#average length
my $average = $sum/(scalar @start); #dividing total length by number of entries
print "Average gene length: $average\n";

#standard deviation
my $sumstdev = 0;
for (my $i = 0; $i < (scalar @start); $i++){
  $sumstdev += (($end[$i]-$start[$i])-$average)**2; #adding all of the (entry lengths - average length)^2
}
my $stdev = sqrt($sumstdev/(scalar @start)); #dividing the sum of st deviations by number of entries, then taking the sq root
print "Standard deviation of gene length: $stdev\n";
