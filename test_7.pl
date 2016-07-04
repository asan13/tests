#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

say '='x30, "\ntest 7: 1/3 - 1/7 secondr";
my $ticks = shift || 1000;
$ticks    = 1000 if $ticks > 1000 || $ticks < 10;
my $tstep = 1 / $ticks;
my ($p3, $p7) = (int $ticks/3, int $ticks/7);
say join ' ', $p3, $p7, $tstep;

my $n = 0;
while () {
    select undef, undef, undef, $tstep;
    ++$n;
    if (not $n % $p3) {
        say "\e[38;5;220mhello\e[0m";
    }
    if (not $n % $p7) {
        say "\e[38;5;101mworld\e[0m";
    }

    last if $n > $ticks * 3
}

