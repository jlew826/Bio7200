#!/usr/bin/perl -w
use strict;

#Given a string made up of { and }, write a script that takes in the pattern from STDIN,
#determines if all the opened curly braces have a paired closing brace, and returns a
#response of “Yes, braces are paired” or “No, braces are not paired”.
#Ensure the pairing component, { { } { } } has all curly braces in pairs
#whereas } } { { { } do not have them in pairs.  A simple counting of opening and
#closing curly braces will return pairing for both cases which will be incorrect!

#prompt user to enter string of curly braces
print "List a string of curly braces:\n";

my $userstring = <STDIN>;
chomp $userstring;

#find only the curly brace characters in the user input string and put into @curlyarr
my @curlyarr = ();
my $curlylength = 0;
my $left = 0; #counter for {'s
my $right = 0; #counter for }'s

foreach my $char (split //, $userstring){
  if ($char eq "{"){
    $curlyarr[$curlylength] = $char;
    $curlylength++;
    $left++;
  }
  if ($char eq "}" ){
    $curlyarr[$curlylength] = $char;
    $curlylength++;
    $right++
  }
}

#checks to see if all opened curly braces have a paired closing brace
my $paircount = "x"; #placeholder to mark all paired braces

#starts from the end to find the innermost curly brace pairs first
for (my $i = ($curlylength-1); $i >= 0; $i--){
  if($curlyarr[$i] eq "{"){
    for (my $j = 0; $j < $curlylength; $j++){
      if(($j > $i)&&($curlyarr[$j] eq "}")){
        $curlyarr[$i] = $paircount;
        $curlyarr[$j] = $paircount;
        last; #exits this inner forloop once the matching brace has been located
      }
    }
  }
}

if ("@curlyarr" =~ /(\{|\})/){ #if there is a remaining, unmatched curly brace in the array
  print "No, braces are not paired\n";
}
else{ #if there are no curly braces in the array (all braces have been replaced with "x")
  print "Yes, braces are paired\n";
}
