#!/usr/bin/perl
use 5.010;

my $tnum = shift || '12';

do {
    say '='x30,  "\ntest 1";
    say "\e[38;5;172m", "
    Асякин Андрей
    skype: andrey_asyakin
    phone: 8 985 423 0739
    site: https://ru.linkedin.com/in/andreyasyakin
    \e[0m";
} if $tnum =~ /1/;


do {
    say "\n", '='x30,  "\ntest 2";
    say '130_000';
} if $tnum =~ /2/;

