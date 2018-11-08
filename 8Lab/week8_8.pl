#!/usr/bin/perl -w
use strict;
use Data::Dumper;
#Your objective is to write a script that reads in these three files in a
#specific logical order and returns the coordinates for the genes in the
#InfectiousDisease-GeneSets.txt file.

my $knownGene = $ARGV[0];
my $kgXref = $ARGV[1];
my $geneSets = $ARGV[2];

#opening knownGene file and extracting the following columns: kgID, txStart, and txEnd into arrays
open (FILE, $knownGene)
  or die ("Can't open $knownGene");
my $kgID;
my $tStart;
my $tEnd;
my @kgID = ();
my @tStart = ();
my @tEnd = ();

while(<FILE>) {
  chomp $_;
  my @columns = split /\t/, $_; #tab is the delimiter
  $kgID[@kgID] = $columns[0]; #kdID column
  $tStart[@tStart] = $columns[3]; #txStart column
  $tEnd[@tEnd] = $columns[4]; #txEnd column
}
close FILE;

#opening kgXref file and extracting the following columns: kgID, and geneSymbol into arrays
open (FILE, $kgXref)
  or die ("Can't open $kgXref");
my $kgXID;
my $geneSymbol;
my @kgXID = ();
my @geneSymbol = ();

while(<FILE>) {
  chomp $_;
  my @columns = split /\t/, $_; #tab is the delimiter
  $kgXID[@kgXID] = $columns[0]; #kgID column
  $geneSymbol[@geneSymbol] = $columns[4]; #geneSymbol column
}
close FILE;

#opening GeneSets file and extracting geneSymbol column into array
open (FILE, $geneSets)
  or die ("Can't open $geneSets");
my $geneSetsSymbol;
my @geneSetsSymbol = ();

while (<FILE>){
  chomp $_;
  $geneSetsSymbol[@geneSetsSymbol]=$_;
}
shift @geneSetsSymbol; #removes header
close FILE;

my $geneSetslength = scalar @geneSetsSymbol; #number of gene names from InfectiousDisease-GeneSets file
my $knownGenelength = scalar @kgID; #number of kgID's from the knownGene file
my $kgXreflength = scalar @kgXID; #number of kgID's from the kgXID file
my %genetokgID = (); #initializing new hash of arrays

#making a hash %genetokgID in which the key is the gene, and value is the kgID
foreach my $gene (@geneSetsSymbol) {
  for(my $i = 0; $i < $kgXreflength; $i++){
    if ($gene eq $geneSymbol[$i]){ #if gene name from GeneSets file matches gene name from kgXID file
      push @{$genetokgID{$gene}}, $kgXID[$i]; #add gene (key) and all kgXIDs (array of values);duplicate kgXIDs are added to the end of array
    }
  }
}

for (my $i = 0; $i < $geneSetslength; $i++){
  foreach my $kg (@{$genetokgID{$geneSetsSymbol[$i]}}[0]){ #only looks at the first instance of the kgID (longest length)
    for (my $j = 0; $j < $knownGenelength; $j++){
      if ($kg eq $kgID[$j]){
        print "$geneSetsSymbol[$i]\t$tStart[$j]\t$tEnd[$j]\n";

        #if you wanted the output to have even columns, I'd use the following print statement instead:
        #printf("%-10s %-15s %-15s\n", $geneSetsSymbol[$i],$tStart[$j],$tEnd[$j]);
      }
    }
  }
}
#print Dumper(\%genetokgID);
