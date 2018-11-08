#!/usr/bin/perl -w
use strict;

#Write a script that will get numbers from the user using STDIN and add them
#to an array.  If the numbers are positive, add them to the back of the array.
#If the numbers are negative, add them to the front of the array.
#Stop if the user enters 0.  Print the array in the end, with the values separated by dots.
#Also print the sum of the numbers entered on a new line.

my @numbers;
my $sum=0;

#prompt user to enter numbers
print "List numbers seperated by a new line: (typing 0 will exit)\n";

while (<STDIN>) {
  chomp ($_);
  if ($_ > 0){ #if number is positive, it gets added to the back of the array
    push (@numbers, $_);
    $sum += $_;
  }
  elsif ($_ < 0) { #if number is negative, it gets added to the front of the array
    unshift (@numbers, $_);
    $sum += $_;
  }
  elsif ($_ == 0){ #if number is 0, exit the while loop
    last;
  }
}
print join( '.', @numbers); #prints the elements of arrays seperated by dots
print "\nThe sum of your numbers = $sum\n"; #prints sum
