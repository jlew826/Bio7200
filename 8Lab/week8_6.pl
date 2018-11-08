#!/usr/bin/perl -w
use strict;

#Detect if an input string of nucleotides from STDIN is self-complimentary;
#your script will return “Yes, it” or “No, it is not”.
#E.g. AACAGTTTATAAACTGTT (AACAGTTTA and its reverse compliment TAAACTGTT) or ACACTGT

#prompt user to enter string of nucleotides
print "List a string of nucleotides:\n";

#capitalize the letters, and chomp
my $userstring = uc(<STDIN>);
chomp $userstring;

#checks to see that string only contains valid nucleotides (A, C, G, or T)
if ($userstring =~ /[^ACGT]/ig){
  print "This is not a valid nucleotide sequence.\n";
  exit;
}

#splits each nucleotide of string and stores in @DNA
my @DNA = split ( //, $userstring );

#checks if DNA is self-complimentary
my $selfcomp = "true"; #set initial boolean to true
my $userstringlength = length $userstring; #find length of the nucleotide string

for (my $i = 0; $i < $userstringlength; $i++) { #$i starts from the beg of the string
  my $j = ($userstringlength - $i) - 1; #$j starts from the end of the string
  if ($i < $j) { #only checks first half against last half
    if (($DNA[$i] eq "A") && ($DNA[$j] ne "T")){ #compliment of A is T
        $selfcomp = "false";
    }
    elsif (($DNA[$i] eq "G") && ($DNA[$j] ne "C")){ #compliment of G is C
        $selfcomp = "false";
    }
    elsif (($DNA[$i] eq "C") && ($DNA[$j] ne "G")){ #compliment of C is G
        $selfcomp = "false";
    }
    elsif (($DNA[$i] eq "T") && ($DNA[$j] ne "A")){ #compliment of T is A
        $selfcomp = "false";
    }
  }
}

if ($selfcomp eq "true"){
  print "Yes, it is\n";
}
else {
  print "No, it is not\n";
}
