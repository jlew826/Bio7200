#!/usr/bin/perl -w
use strict;

my $input1 = $ARGV[0];
my $input2 = $ARGV[1];
my $output = $ARGV[2];
my $seqtype = $ARGV[3];

if ($seqtype eq "n"){
  system("makeblastdb -in $input1 -parse_seqids -dbtype nucl"); #making database from input1 sequences
  system("makeblastdb -in $input2 -parse_seqids -dbtype nucl"); #making database from input2 sequences
  my $numhitsfor1 = `blastn -query $input1 -db $input2 -outfmt 6|wc -l`; #counting number of lines resulting from blastn -outfmt6, in which each line represents a hit
  my $numhitsfor2 = `blastn -query $input2 -db $input1 -outfmt 6|wc -l`; #counting number of lines resulting from blastn -outfmt6, in which each line represents a hit
  system("blastn -query $input1 -db $input2 -outfmt 7|awk \'/hits found/{getline;print}\'|grep -v \"#\"|sed 's/^....//' > output1.txt"); #only printing the first (best) hit for each seq since in -outfmt7, hits for each seq are sorted
  system("blastn -query $input2 -db $input1 -outfmt 7|awk \'/hits found/{getline;print}\'|grep -v \"#\"|sed 's/^....//' > output2.txt"); #only printing the first (best) hit for each seq since in -outfmt7, hits for each seq are sorted
  system("awk \'FNR==NR{a[\$1,\$2]=\$0;next}{if(b=a[\$2,\$1]){print b}}\' output1.txt output2.txt > $output"); #looking for reciprocal best hits and giving them as output
  my $numOrtholog = `cat $output|wc -l`; #counting number of lines from $output file where each line represents orthologous genes
  system("echo \"Initial blast hits for $input1 \=$numhitsfor1\" > README.txt"); #adding initial blast hits to README file
  system("echo \"Initial blast hits for $input2 \=$numhitsfor2\" >> README.txt"); #adding initial blast hits to README file
  system("echo \"Number of orthologous genes \=$numOrtholog\" >> README.txt"); #adding number of orthologous genes to README file
  system("rm $input1.* $input2.* output*"); #removes temporary files
}

elsif ($seqtype eq "p"){
  system("makeblastdb -in $input1 -parse_seqids -dbtype prot"); #making database from input1 sequences
  system("makeblastdb -in $input2 -parse_seqids -dbtype prot"); #making database from input2 sequences
  my $numhitsfor1 = `blastp -query $input1 -db $input2 -outfmt 6|wc -l`; #counting number of lines resulting from blastn -outfmt6, in which each line represents a hit
  my $numhitsfor2 = `blastp -query $input2 -db $input1 -outfmt 6|wc -l`; #counting number of lines resulting from blastn -outfmt6, in which each line represents a hit
  system("blastp -query $input1 -db $input2 -outfmt 7|awk \'/hits found/{getline;print}\'|grep -v \"#\"|sed 's/^....//' > output1.txt"); #only printing the first (best) hit for each seq since in -outfmt7, hits for each seq are sorted
  system("blastp -query $input2 -db $input1 -outfmt 7|awk \'/hits found/{getline;print}\'|grep -v \"#\"|sed 's/^....//' > output2.txt"); #only printing the first (best) hit for each seq since in -outfmt7, hits for each seq are sorted
  system("awk \'FNR==NR{a[\$1,\$2]=\$0;next}{if(b=a[\$2,\$1]){print b}}\' output1.txt output2.txt > $output"); #looking for reciprocal best hits and giving them as output
  my $numOrtholog = `cat $output|wc -l`; #counting number of lines from $output file which represent orthologous genes
  system("echo \"Initial blast hits for $input1 \=$numhitsfor1\" > README.txt"); #adding initial blast hits to README file
  system("echo \"Initial blast hits for $input2 \=$numhitsfor2\" >> README.txt"); #adding initial blast hits to README file
  system("echo \"Number of orthologous genes \=$numOrtholog\" >> README.txt"); #adding number of orthologous genes to README file
  system("rm $input1.* $input2.* output*"); #removes temporary files
}

else {
  print "Cannot recognize type of sequence. Try \"n\" for nucleotide or \"p\" for protein.\n";
}
