#!/usr/bin/perl -w
use strict;

my $inputfile = $ARGV[0];

#finds out what the file type is
my $filetype = `head -1 $inputfile | awk \'{if (\$1==\"ID\") print \"EMBL\";
  else if (\$1~ /^@/) print \"FASTQ\";
  else if (\$1 == \"LOCUS\") print \"GenBank\";
  else if (\$1 ~/^#/) print \"MEGA\";
  else if (\$1~/^>/) print \"PIR\";
  else print \"could not recognize file type\"}\'`;

open (FILE, $inputfile)
  or die ("Can't open $inputfile\n");

my $lines;
my @lines=();

my @inputwoext = split (/\./, $inputfile);
pop @inputwoext;
my $inputwoext = join '.', @inputwoext;

while(<FILE>) {
  chomp $_;
  $lines[@lines] = $_;
}
close FILE;

if ($filetype eq "EMBL\n"){
  my $sequence = "";
  my $start = 0;
  my $descriptionline = "";
  for (my $i = 0; $i < scalar @lines; $i++){
    if ($lines[$i] =~ /^DE/){
      my $fulldesline = $lines[$i];
      my @fields = split(/^DE\s+/, $fulldesline);
      $descriptionline = ">".$descriptionline.$fields[1]."\n";
    }
    if ($lines[$i] =~ /^SQ/){
      $start = $i+1;
    }
  }
  for (my $i = $start; $i < scalar @lines; $i++){
    foreach my $char (split//,$lines[$i]){
      if ($char =~ /[a-z]/){
        $sequence = $sequence.$char;
      }
    }
  }
  $sequence = uc($sequence); #capitalize sequence

  if ($sequence =~ /^[ACTG]+$/){
    $sequence = join ("\n", ($sequence =~ /.{1,80}/g)); #make a new line after every 80 characters
    my $fasta = $descriptionline.$sequence;
    open(my $newfile, '>', "$inputwoext.fna");
    print $newfile "$fasta\n";
    close $newfile;
  }
  else{
    $sequence = join ("\n", ($sequence =~ /.{1,80}/g)); #make a new line after every 80 characters
    my $fasta = $descriptionline.$sequence;
    open(my $newfile, '>', "$inputwoext.faa");
    print $newfile "$fasta\n";
    close $newfile;
  }
}

elsif ($filetype eq "FASTQ\n") {
  my @fastaarr = ();
  my $fastacounter = 0;
  for (my $i = 0; $i < scalar @lines; $i++){
    if ($lines[$i] =~ /^@/){
      $lines[$i] =~ s/@/>/;
      $fastaarr[$fastacounter] = $lines[$i];
      $fastacounter++;
      $fastaarr[$fastacounter] = join ("\n", ($lines[$i+1] =~ /.{1,80}/g));
      $fastacounter++;
    }
  }
  if ($fastaarr[1]=~ /^[ACTG\.]+$/m){
    open(my $newfile, '>', "$inputwoext.fna");
    print $newfile "$_\n" for @fastaarr;
    close $newfile;
  }
  else {
    open(my $newfile, '>', "$inputwoext.faa");
    print $newfile "$_\n" for @fastaarr;
    close $newfile;
  }
}

elsif ($filetype eq "GenBank\n"){
  my $descriptionline = "";
  my $start = 0;
  my $sequence = "";
  for (my $i = 0; $i < scalar @lines; $i++){
    if ($lines[$i] =~ /^DEFINITION/){
      my $fulldesline = $lines[$i];
      my @fields = split(/^DEFINITION\s+/, $fulldesline);
      $descriptionline = ">".$descriptionline.$fields[1]."\n";
    }
    if ($lines[$i] =~ /^ORIGIN/){
      $start = $i+1;
    }
  }
  for (my $j = $start; $j < scalar @lines; $j++){
    foreach my $char (split//,$lines[$j]){
      if ($char =~ /[a-z]/){
        $sequence = $sequence.$char;
      }
    }
  }
  $sequence = uc($sequence); #capitalize sequence
  if ($sequence =~ /^[ACTG]+$/){
    $sequence = join ("\n", ($sequence =~ /.{1,80}/g)); #make a new line after every 80 characters
    my $fasta = $descriptionline.$sequence;
    open(my $newfile, '>', "$inputwoext.fna");
    print $newfile "$fasta\n";
    close $newfile;
  }
  else{
    $sequence = join ("\n", ($sequence =~ /.{1,80}/g)); #make a new line after every 80 characters
    my $fasta = $descriptionline.$sequence;
    open(my $newfile, '>', "$inputwoext.faa");
    print $newfile "$fasta\n";
    close $newfile;
  }
}

elsif ($filetype eq "MEGA\n"){
  my %descriptions = ();
  my $DNA = "true";
  for (my $i = 0; $i < scalar @lines; $i++){
    if ($lines[$i] =~ /^#(?!(mega.*)).+\s+[a-z]/){
      $lines[$i] =~ s/#/>/;
      my @fields = split (/\s+/, $lines[$i]);
      $fields[1] = uc($fields[1]);
      if ($fields[1]!~ /^[ACTG]+$/){
        $DNA = "false";
      }
      push @{$descriptions{$fields[0]}}, $fields[1];
    }
  }
  print $DNA;
  if ($DNA eq "false"){
    open(my $newfile, '>', "$inputwoext.faa");
    foreach my $key (sort keys %descriptions){
      print $newfile "$key\n";
      foreach my $array_item (@{ $descriptions{$key} }){
        print $newfile "$array_item";
      }
      print $newfile "\n";
    }
    close $newfile;
  }
  else {
    open(my $newfile, '>', "$inputwoext.fna");
    foreach my $key (sort keys %descriptions){
      print $newfile "$key\n";
      foreach my $array_item (@{ $descriptions{$key} }){
        print $newfile "$array_item";
      }
      print $newfile "\n";
    }
    close $newfile;
  }
}

elsif ($filetype eq "PIR\n"){
  my @fastaarr = ();
  my $fastacounter = 0;
  for (my $i = 0; $i < scalar @lines; $i++){
    $lines[$i] =~ s/\*//;
    if ($lines[$i] =~ /^>/){
      $lines[$i] =~ s/>..;/>/;
      $fastaarr[$fastacounter] = $lines[$i];
      $fastacounter++;
    }
    elsif ($lines[$i] =~ /[^A-Z]+/){ #skips line that is not a description or sequence
      next;
    }
    elsif ($lines[$i] =~ /^\s*$/){ #skips line that is blank
      next;
    }
    else{
      $fastaarr[$fastacounter] = $lines[$i];
      $fastacounter++;
    }
  }
  if ($fastaarr[1]=~ /^[ACTG\.]+$/m){
    open(my $newfile, '>', "$inputwoext.fna");
    print $newfile "$_\n" for @fastaarr;
    close $newfile;
  }
  else {
    open(my $newfile, '>', "$inputwoext.faa");
    print $newfile "$_\n" for @fastaarr;
    close $newfile;
  }
}
else{
  print "$filetype";
}
