#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

use Test::More;

use StrLib qw/x_strstr/;

ok !x_strstr(undef, undef);

my $h = x_strstr('hello, world', 'world');

is ref $h, 'HASH';
is_deeply $h, {status => 'ok', found => 'world', source => 'hello, world'};

$h = x_strstr('aaa', 'b');
is ref $h, 'HASH';
is_deeply $h, {status => 'fail'};

is x_strstr('abcde', 'a')->{found}, 'abcde';
is x_strstr('abcde', 'e')->{found}, 'e';

$h = x_strstr('abcde', 'd');
eval { $h->{$_} = 1 for qw/status found source/ };
ok !$@;

diag q!x_strstr('hello', 'world'): !, x_strstr('hello', 'hello')->{found};
diag q!x_strstr('hello', 'o'): !,     x_strstr('hello', 'e')->{found};

done_testing;
