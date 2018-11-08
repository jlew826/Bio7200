#!/usr/bin/perl -w
use strict;
use Getopt::Long qw(GetOptions);
use List::Util qw[min max];

#initialzing variables
my $inputfile1 = "";
my $inputfile2 = "";
my $minoverlap = 100; #default overlap is 100%
my $joinflag;
my $outputfile = "";
my $sorttest1 = "";
my $sorttest2 = "";
my @overlapBed1 = (); #array of overlap coordinatres from first set
my @overlapBed2 = (); #array of overlap coordinatres from second set

#options for this program
GetOptions(
  'i1=s' => \$inputfile1,
  'i2=s' => \$inputfile2,
  'm=i'=> \$minoverlap, #take in an option for the minimum percent overlap
  'j' => \$joinflag, #option for joining first and second set in the output file
  'o=s' => \$outputfile,
) or die "Usage: $0 -i1 <Input file 1> -i2 <Input file 2> -m <INT: minimal overlap> -j [Optional: join the two entries] –o <Output file>\n";

#check to see if both input files are sorted. exit program if they are not sorted.
$sorttest1 = `gsort -k1,1 -k2,2n -k3,3n -c $inputfile1 2>&1`; #stores STDERR to a variable
$sorttest2 = `gsort -k1,1 -k2,2n -k3,3n -c $inputfile2 2>&1`; #stores STDERR to a variable

if (($sorttest1 =~ /.+/) && ($sorttest2 =~ /.+/)) {
  print "$inputfile1 and $inputfile2 are not sorted. Please sort before running command.\n";
  exit 0;
}
elsif ($sorttest1 =~ /.+/) {
  print "$inputfile1 is not sorted. Please sort before running command.\n";
  exit 0;
}
elsif ($sorttest2 =~ /.+/){
  print "$inputfile2 is not sorted. Please sort before running command.\n";
  exit 0;
}

#opening and extracting data and placing it into arrays from first file
open (FILE, $inputfile1)
  or die ("Can't open $inputfile1\n");

my @lines1 = ();
my @chr1 = ();
my @start1 = ();
my @end1 = ();
my $lines1;
my $chr1;
my $start1;
my $end1;

  while(<FILE>) {
    chomp $_;
    $lines1[@lines1] = $_;
    my @columns = split /\t/, $_; #tab is the delimiter
    $chr1[@chr1] = $columns[0]; #chr column
    $start1[@start1] = $columns[1]; #start column
    $end1[@end1] = $columns[2]; #end column
  }
close FILE;

#opening and extracting data and placing it into arrays from second file
open (FILE, $inputfile2)
  or die ("Can't open $inputfile2\n");

my @lines2 = ();
my @chr2 = ();
my @start2 = ();
my @end2 = ();
my $lines2;
my $chr2;
my $start2;
my $end2;

  while(<FILE>) {
    chomp $_;
    $lines2[@lines2] = $_;
    my @columns = split /\t/, $_; #tab is the delimiter
    $chr2[@chr2] = $columns[0]; #chr column
    $start2[@start2] = $columns[1]; #start column
    $end2[@end2] = $columns[2]; #end column
  }
close FILE;

#subroutine to find the overlapping coordinates
sub findoverlap {
  my ($lines1_ref, $lines2_ref, $chr1_ref, $chr2_ref, $start1_ref, $start2_ref, $end1_ref, $end2_ref) = @_;
my @lines1_ref = @{ $lines1_ref }; #dereferencing and copying each array
my @lines2_ref = @{ $lines2_ref };
my @chr1_ref = @{ $chr1_ref };
my @chr2_ref = @{ $chr2_ref };
my @start1_ref = @{ $start1_ref };
my @start2_ref = @{ $start2_ref };
my @end1_ref  = @{ $end1_ref };
my @end2_ref = @{ $end2_ref };

my $overlapnum = 0;
my $overlappercent = 0;
my $counter = 0; #seed to keep track of where the last overlap happened

  for (my $i = 0; $i < scalar @lines1_ref; $i++){
    OUTER:
    for (my $j = $counter; $j < scalar @lines2_ref; $j++){
      if ($chr1_ref[$i] eq $chr2_ref[$j]) {
        if ($start1_ref[$i] <= $end2_ref[$j] && $start2_ref[$j] <= $end1_ref[$i]) { #checking to see if there's overlap
          my $currentmin = min($end1_ref[$i], $end2_ref[$j]);
          my $currentmax = max($start1_ref[$i], $start2_ref[$j]);
          $overlapnum = $currentmin - $currentmax + 1; #calculating number of overlap bases
          $overlappercent = ($overlapnum/($end1_ref[$i] - $start1_ref[$i]+1)) * 100; #calculating percent overlap of bases
          if ($overlappercent >= $minoverlap){
            push @overlapBed1, $lines1_ref[$i]; #storing the overlap coordinates in a new array
            push @overlapBed2, $lines2_ref[$j]; #storing the overlap coordinates in a new array
            $counter = $j; #sets the seed to where the last set of coordinate overlap happened
            last OUTER; #exits the nested for loop; makes sure first set of overlap is only captured once
          }
          else{
            next;
          }
        }
        else{
          next;
        }
      }
      else {
        my $diff = $chr1_ref[$i] cmp $chr2_ref[$j];
        if (($chr1_ref[$i-1] eq $chr2_ref[$j]) && ($diff < 0)){
          $counter = $j;
          last OUTER;
        }
        next;
      }

    }
  }
  return @overlapBed1;
  return @overlapBed2;
}

findoverlap(\@lines1, \@lines2, \@chr1, \@chr2, \@start1, \@start2, \@end1, \@end2);

#creating new output file
open my $newfile, '>', $outputfile or die "Cannot open $outputfile: $!";
for (my $i = 0; $i < scalar @overlapBed1; $i++){
  if ($joinflag) { #print both the member of the first set and the member of the second set that it overlaps with
    print $newfile "$overlapBed1[$i]\t$overlapBed2[$i]\n";
  }
  else { #only print first set
    print $newfile "$overlapBed1[$i]\n"; # Print each entry in our array to the file
  }
}
close $newfile;
