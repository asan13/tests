#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

sub uri_escape {
    my $uri = shift;
    $uri =~ s/(.)/'%'.(sprintf '%02X', ord $1)/ge;
    $uri;
}

say '='x30, "\ntest5: uri_escape";
uri_escape(' 12') eq '%20%31%32' or die 'uri_escape invalid';

for ( ' 12', qw/asdf фыва 12asфы/ ) {
    say "$_: ", uri_escape $_;
}

