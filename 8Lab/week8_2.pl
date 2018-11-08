#!/usr/bin/perl -w
use strict;

# Given two variables, $a = 10 and $b = 20, write a script to swap
# them without the use of any temporary variables.

my $a = 10;
my $b = 20;
print "a = $a, b = $b.\n";

#using an arithmetic equation to swap
$a = $a + $b; # a = 10 + 20 = 30
$b = $a - $b; # b = 30 - 20 = 10
$a = $a - $b; # a = 30 - 10 = 20

print "After swapping: a = $a, b = $b.\n";
