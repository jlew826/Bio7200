#!/usr/bin/perl -w
use strict;
use Getopt::Long qw(GetOptions);
use Bio::Tools::Run::StandAloneBlastPlus;
use Bio::SearchIO;

#options used when calling this command
my $usage = "USAGE: $0 -i [input_file] -d [sequence_db.fa] -m [blast_method] -o [output_file]\n";
my $inputfile = "";
my $db = "";
my $blastmethod = "";
my $outputfile = "";

#makes sure the right number of arguments are used
if (scalar @ARGV != 8){
  print "Incorrect usage.\n$usage";
  exit;
}

GetOptions(
  'i=s' => \$inputfile,
  'd=s' => \$db,
  'm=s' => \$blastmethod,
  'o=s' => \$outputfile,
) or die $usage;


# creating StandAloneBlastPlus object to read in the database file, and create the database
my $fac = Bio::Tools::Run::StandAloneBlastPlus->new(
   -db_name => 'mydb',
   -db_data => "$db",
   -create => 1
 );

# running the blastmethod using inputfile as the query
$fac->$blastmethod(
    -query => $inputfile,
    -outfile => "myblastfile",
  );

# creating SearchIO object to read in the blast file
my $searchio = Bio::SearchIO->new(
    -file => 'myblastfile',
    -format => "blast"
  );

# parsing the top two hits for each sequence
while (my $result = $searchio->next_result) {
  my $counter = 0;
  while ( my $hit = $result->next_hit() ) {
    while( my $hsp = $hit->next_hsp() ) {
      if($counter < 2){
        open(my $fh, '>>', "$outputfile") or die "Could not open file '$outputfile' $!";
        print $fh join("\t", $hit->name, $hit->description, $hsp->bits)."\n";
        close $fh;
        $counter++;
      }
    }
  }
}

system ("rm my*"); #removing temporary files
