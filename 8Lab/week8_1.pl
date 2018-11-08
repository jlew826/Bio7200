#!/usr/bin/perl -w
use strict;

# Given two variables, $a = 10 and $b = 20, write a script to swap them using a temporary variable
my $a = 10;
my $b = 20;
print "a = $a, b = $b.\n";

my $temp = $b; #the temporary variable

$b = $a;
$a = $temp;

print "After swapping using a temporary variable: a = $a, b = $b. \n";
