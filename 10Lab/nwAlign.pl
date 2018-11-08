#!/usr/bin/perl -w
use strict;

#usage = ./nwAlign.pl <input FASTA file 1> <input FASTA file 2>

my $inputfile1 = $ARGV[0];
my $inputfile2 = $ARGV[1];

open (FILE, $inputfile1)
  or die ("Can't open $inputfile1\n");

my $file1lines;
my @file1lines=();

#inserting all lines of file 1 into array @file1lines
while(<FILE>) {
  chomp $_;
  if ($_ =~ /^>/){
  }
  else {
    $file1lines[@file1lines] = $_;
  }
}
close FILE;

open (FILE, $inputfile2)
  or die ("Can't open $inputfile2\n");

my $file2lines;
my @file2lines=();

#inserting all lines of file 2 into array @file2lines
while(<FILE>) {
  chomp $_;
  if ($_ =~ /^>/){
  }
  else {
    $file2lines[@file2lines] = $_;
  }
}
close FILE;

#creating array of seq1 nucleotides
my @seq1DNA;
my $seq1DNAlen = 0;
for (my $i = 0; $i < scalar @file1lines; $i++){
  foreach my $char (split//,$file1lines[$i]){
    $seq1DNA[$seq1DNAlen] = $char;
    $seq1DNAlen++;
  }
}

#creating array of seq2 nucleotides
my @seq2DNA;
my $seq2DNAlen = 0;
for (my $i = 0; $i < scalar @file2lines; $i++){
  foreach my $char (split//,$file2lines[$i]){
    $seq2DNA[$seq2DNAlen] = $char;
    $seq2DNAlen++;
  }
}

#print $seq1DNAlen;
#print "\n";
#print $seq2DNAlen;
#print "\n";

#intializing matrix
my @matrix = ([("x") x ($seq1DNAlen+1)], [("x") x ($seq2DNAlen+1)]);

#filling first row of matrix with seq1
for (my $i = 0; $i < $seq1DNAlen; $i++){
  $matrix [2+$i][0] = $seq1DNA[$i];
}

#print "\n$matrix[4][0]\n";
#filling first column of matrix with seq 2
for (my $i = 0; $i < $seq2DNAlen; $i++){
  $matrix [0][2+$i] = $seq2DNA[$i];
}
#print "\n$matrix[0][4]\n";

#starting with first score 0 in upper left corner
$matrix [1][1] = 0;

#initializing first row of scores;
for (my $i = 2; $i < $seq2DNAlen+2; $i++){
  $matrix[1][$i] = $matrix[1][$i-1] - 1;
}

#initializing first column of scores;
for (my $i = 2; $i < $seq1DNAlen+2; $i++){
  $matrix[$i][1] = $matrix[$i-1][1] - 1;
}

my $a;
my $b;
my $c;
my $max;

#filling rest of matrix based on the scoring system
for (my $across = 2; $across < $seq1DNAlen+2; $across++){
  for (my $down = 2; $down < $seq2DNAlen+2; $down++){
    $a = ($matrix[$across][$down-1]) - 1;
    $b = ($matrix[$across-1][$down]) - 1;
    if ($matrix[0][$across] eq $matrix[$down][0]){ #match
        $c = ($matrix[$across-1][$down-1]) + 1;
    }
    else { #mismatch
      $c = ($matrix[$across-1][$down-1]) - 1;
    }

    #finding the max between the 3 types of scores
    if($a>=$b && $a>=$c){
    $max = $a;
    }
    elsif($b>=$c && $b>=$a){
    $max = $b;
    }
    else{
    $max = $c;
    }
    $matrix[$across][$down] = $max;
  }

}

my @align1;
my @align2;
my $aligncounter = 0;
my $across2 = $seq1DNAlen+2; #backtracking step starts from the very last cell filled
my $down2 = $seq2DNAlen+2; #backtracking step starts from the very last cell filled

#print "$matrix[0][12]";

#backtracking and finding optimal alignment
until(($across2 == 1) && ($down2 == 1)){
  #if there is a match the path moves diagonally left
  if ($matrix[0][$across2] eq $matrix[$down2][0]){;# || (($matrix[$across2-1][$down2-1] >= $matrix[$across2-1][$down2]) && ($matrix[$across2-1][$down2-1] >= $matrix[$across2][$down2-1]))) {
    $align2[$aligncounter] = $matrix[0][$across2];
    $align1[$aligncounter] = $matrix[$down2][0];
    $aligncounter++;
    $across2--;
    $down2--;
  }
  #if the maximum score is obtained by moving diagonally left
  elsif(($matrix[$across2-1][$down2-1] >= $matrix[$across2-1][$down2]) && ($matrix[$across2-1][$down2-1] >= $matrix[$across2][$down2-1])){
    $align2[$aligncounter] = $matrix[0][$across2];
    $align1[$aligncounter] = $matrix[$down2][0];
    $aligncounter++;
    $across2--;
    $down2--;
  }
  #if the maximum score is obtained by moving vertically
  elsif(($matrix[$across2][$down2-1] >= $matrix[$across2-1][$down2-1]) && ($matrix[$across2][$down2-1] >= $matrix[$across2-1][$down2])){
    $align2[$aligncounter] = "-"; #indicates gap
    $align1[$aligncounter] = $matrix[$down2][0];
    $aligncounter++;
    $down2--;
  }
  #if the maximum score is obtained by moving horizontally
  elsif(($matrix[$across2-1][$down2] >= $matrix[$across2-1][$down2-1]) && ($matrix[$across2-1][$down2] >= $matrix[$across2][$down2-1])){
    $align2[$aligncounter] = $matrix[0][$across2];
    if ($aligncounter == 0){
      $align1[$aligncounter] = $matrix[0][$across2];
    }
    else{
      $align1[$aligncounter] = "-"; #indicates gap
    }
    $aligncounter++;
    $across2--;
  }

}

#print "$aligncounter\n";

for (my $j = 0; $j < $aligncounter; $j++){
  if ($align2[$j] eq ""){
    $align2[$j] = "-";
  }
}

my @match;
my $alignmentscore = 0;
for (my $i = 0; $i < scalar @align1; $i++){
  if ($align1[$i] eq $align2[$i] && $align1[$i] ne "-" && $align2[$i] ne "-"){
    $match[$i] = "|";
    $alignmentscore++; #add for match
  }
  else {
    $match[$i] = " ";
    $alignmentscore--; #subtract for gap or mismatch
  }
}

print join("", reverse @align1); #printing arrays backwards
print "\n";
print join("", reverse @match);
print "\n";
print join("", reverse @align2);
print "\n";
print "Alignment score = $alignmentscore\n"

###test printing array
