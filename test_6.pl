#!/usr/bin/perl
use common::sense;

use Test::More;

diag '='x30, 'test 6: unit test for MyModule::foo2';

{
	no warnings 'redefine';
	*MyModule::foo2 = sub { die "foo2 call\n" };
}

sub must_call_foo2($$) {
	my ($a1, $a2) = @_;
	return $a1 + $a2 > 20 && $a1 + $a2 < 30;
}

is MyModule::foo1(43, 1), 42, 'foo1 result';


my @tests = (
    1,    2,
    10,  10,
    10,  15,
    20,   9,
    20,  10,
    20, 100,
);

my $n = 0;
while (my ($a1, $a2) = splice @tests, 0, 2) {
    ++$n;
    my $pref = "test foo2 call $n ($a1, $a2)";

    eval { MyModule::foo1($a1, $a2) };
    if ($@ && $@ !~ /^foo2 call/) {
        die "$pref unexpected exception: $@";
    }

    if ( must_call_foo2($a1, $a2) ) {
        like $@, qr/foo2 call/, "$pref: foo2 call"; 
    }
    else {
        ok !$@, "$pref: foo2 not call";
    }
}

done_testing;


BEGIN {
	package MyModule;
	sub foo2 {
		die "ops!\n";	
	}

	sub foo1 {
		my ($a1, $a2) = @_;
		if ($a1 + $a2 > 20 and $a1 + $a2 < 30) {
			foo2()
		}
		return $a1 - $a2;
	}
}
