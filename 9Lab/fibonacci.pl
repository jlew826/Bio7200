#!/usr/bin/perl -w
use strict;

sub fibonacci {
  my $fibposition = shift; #takes in first/only element of the passed data and sets it as a variable
  my $fibnumber;

  if ($fibposition eq 1){
    $fibnumber = 0;
  }
  elsif ($fibposition eq 2){
    $fibnumber = 1;
  }
  else {
    $fibnumber = (fibonacci($fibposition-1) + fibonacci($fibposition-2));
  }
  return $fibnumber;
}

my @fibarr;

for (my $i = 0; $i < $ARGV[0]; $i++){ #enters the returned $currentnum to the correct index of the @fibarr
   $fibarr[$i] = fibonacci($i+1); #calls subroutine fibseq for $i+1 since fibseq cannot be called for 0;
}

print join( ',', @fibarr ); #prints the array separated by ','
print "\n";
