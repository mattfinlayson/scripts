#!/usr/bin/perl -w

#
# Copyright (C) 2009 Alex Linke, <alex@use-strict.de>
#
# This script is provided under the terms of the MIT license.
#

use strict;
use LWP::UserAgent;
use URI::Escape    qw/uri_escape/;
use Encode         qw/encode/;
use HTML::Entities qw/decode_entities/;

use constant BASEURL => "http://lyrics.wikia.com/lyrics/";

#die "usage: $0 artist title\n" unless scalar(@ARGV) == 2;

#my ($artist, $title) = @ARGV;

my $artist = `mpc --format '%artist%' | head -n 1 | tr -d '\n'`;
my $title = `mpc --format '%title%' | head -n 1 | tr -d '\n'`;

my $url = BASEURL .
    join(":",
        uri_escape(join("_", map { ucfirst } split(/\s+/, $artist))),
        uri_escape(join("_", map { ucfirst } split(/\s+/, lc($title))))
    );

## Create the user agent...
my $browser = new LWP::UserAgent();
$browser->timeout(60); # seconds

## ...and try to retrieve the content
my $response = $browser->get($url);

if ($response->is_success())
{
    ## Parse the HTML using a regex in order to avoid introducing another
    ## dependency...
    ## Strip off ringtone advertisements (rtMatcher) as well
    if ($response->content =~ m(
        <div\s+class=['"]lyricbox['"]\s*>
            (?:<div\s+class=['"]rtMatcher['"]\s*>.*?</div>)?
            (.*?)
            (?:<div\s+class=['"]rtMatcher['"]\s*>.*?</div>)?
        </div>
        )isx
    )
    {
        my $lyrics  = encode("UTF-8", decode_entities($1));
        my $heading = "$artist - $title";

        # Process retrieved lyrics
        $lyrics =~ s(<br\s*/>)(\n)gi;
        $lyrics =~ s(<!--.*?-->)()gs;

	#print $heading, "\n", "=" x length($heading), "\n\n", $lyrics, "\n";
	#print "$lyrics \n";

	if (-e "/home/fsk141/.lyrics/$heading.txt") {
		#open( FILE, "< /home/fsk141/.lyrics/$heading.txt" );
		#while( <FILE> ) {
		#	print;
		#}
		#close FILE;
		print "";	
	} else {
		open (MYFILE, ">>/home/fsk141/.lyrics/$heading.txt");
		print MYFILE "$lyrics \n";
		close (MYFILE);

		#open( FILE, "< /home/fsk141/.lyrics/$heading.txt" );
		#while( <FILE> ) {
		#	print;
		#}
		#close FILE;
	}


        exit(0);
    }
}

exit(0);

# vim: sts=4 sw=4 enc=utf-8 ai et
