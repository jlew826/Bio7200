#!/usr/bin/perl -w
use strict;

#Download the RepeatMasker table for the hg19 version of the human genome using the
#Table Browser on the UCSC Genome Browser.  The RepeatMasker table is under the ‘Repeats’ group.
#There are three columns in the RepeatMasker table which classify the repeat: repClass, repFamily and repName.
#Using Perl, count the occurrences of every repName, repFamily and repClass in the output file.
#Print the results in some sort of table, i.e. format the results in some visually pleasing way.

open (FILE, "<$ARGV[0]")
  or die ("Can't open $ARGV[0]"); #error message if file cannot be opened

my $repName;
my $repClass;
my $repFamily;
my @repName=();
my @repClass=();
my @repFamily=();
my %NameCount;
my %ClassCount;
my %FamilyCount;

#extract data from repName, repClass, and repFamily columns and each line is added to its respective array
while(<FILE>) {
  chomp $_;
  my @columns = split /\t/, $_; #tab is the delimiter
  $repName[@repName] = $columns[10]; #repName is in the 10th field
  $repClass[@repClass] = $columns[11]; #repClass is in the 11th field
  $repFamily[@repFamily] = $columns[12]; #repFamily is in the 12th field
}
close FILE;

#removes the first element of the arrays (removes the headers)
shift @repName;
shift @repClass;
shift @repFamily;

#iterate over the elements of the @repName and increments the counter for that element
foreach my $name (@repName) {
  $NameCount{$name}++;
}

#prints out the repNames, and the count of occurrences in the outputfile
print "repName\t\t\tcount of occurrences\n";
print "--------------------------------------------\n";
foreach my $name (sort keys %NameCount){
  printf "%-30s %s\n", $name, $NameCount{$name};
}
print "############################################\n\n";

#iterate over the elements of the @repClass and increments the counter for that element
foreach my $class (@repClass) {
  $ClassCount{$class}++;
}

#prints out the repClass, and the count of occurrences in the outputfile
print "repClass\t\tcount of occurrences\n";
print "--------------------------------------------\n";
foreach my $class (sort keys %ClassCount){
  printf "%-30s %s\n", $class, $ClassCount{$class};
}
print "############################################\n\n";

#iterate over the elements of the @repFamily and increments the counter for that element
foreach my $family (@repFamily) {
  $FamilyCount{$family}++;
}

#prints out the repFamily, and the count of occurrences in the outputfile
print "repFamily\t\tcount of occurrences\n";
print "--------------------------------------------\n";
foreach my $family (sort keys %FamilyCount){
  printf "%-30s %s\n", $family, $FamilyCount{$family};
}
print "############################################\n\n";
