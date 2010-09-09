#!/usr/bin/perl -w

#
# Copyright (C) 2009 Alex Linke, <alex@use-strict.de>
#
# This script is provided under the terms of the MIT license.
#

use strict;
#use Encode         qw/encode/;

my $artist = `/usr/local/bin/mpc --format '%artist%' | head -n 1 | tr -d '\n'`;
my $title = `/usr/local/bin/mpc --format '%title%' | head -n 1 | tr -d '\n'`;

my $heading = "$artist - $title";

	if (-e "/Users/jgerold/.lyrics/$heading.txt") {
		open( FILE, "< /Users/jgerold/.lyrics/$heading.txt" );
		while( <FILE> ) {
			print;
		}
		close FILE;
		print "";	
	} else {
		system("/Users/jgerold/.scripts/02-from-lyrics-wikia-com.pl");

		open( FILE, "< /Users/jgerold/.lyrics/$heading.txt" );
		while( <FILE> ) {
			print;
		}
		close FILE;
	}
