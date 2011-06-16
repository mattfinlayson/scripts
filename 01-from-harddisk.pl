#!/usr/bin/perl -w

#
# Copyright (C) 2009 Alex Linke, <alex@use-strict.de>
#
# This script is provided under the terms of the MIT license.
#

use strict;
#use Encode         qw/encode/;

my $artist = `mpc --format '%artist%' | head -n 1 | tr -d '\n'`;
my $title = `mpc --format '%title%' | head -n 1 | tr -d '\n'`;

my $heading = "$artist - $title";

	if (-e "/home/fsk141/.lyrics/$heading.txt") {
		open( FILE, "< /home/fsk141/.lyrics/$heading.txt" );
		while( <FILE> ) {
			print;
		}
		close FILE;
		print "";	
	} else {
		system("/home/fsk141/.scripts/02-from-lyrics-wikia-com.pl");

		open( FILE, "< /home/fsk141/.lyrics/$heading.txt" );
		while( <FILE> ) {
			print;
		}
		close FILE;
	}
