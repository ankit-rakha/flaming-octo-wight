#!/usr/bin/perl

#********************************************************************

use strict;
use warnings;

my $file = $ARGV[0];
open my $info, $file or die "Could not open $file: $!";

while( my $line = <$info>)  {   

my $decimal_notation = sprintf("%.10g", $line);
print "$decimal_notation\n";
}

close $info;

#********************************************************************
