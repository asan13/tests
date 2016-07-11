#!/usr/bin/perl
use common::sense;

use AnyEvent;
use Test::More;

my $tnum = shift || '34';

if ( $tnum =~ /3/ ) {
    diag '='x30, "\ntest 3: foo_singleton";
    my $conn = Foo::foo_singleton(myhost => 1234);
    ok ref $conn && $conn->isa('MyDB');
    is Foo::foo_singleton(myhost => $_), $conn for 1..3; 
}

if ($tnum =~ /4/) {
    diag '='x30, "\ntest 4: AnyEvent foo_singleton";
    my $cv = AE::cv;

    my $conn;
    my ($w, $call);
    $w = AE::timer 1, 1, sub { 
        FooAny::foo_singleton(myhost => 1234, sub {
            my $c = shift;
            unless ($conn) {
                $conn = $c;
                diag 'first call';
            }
            ++$call;
            is $conn, $c, "call $call";
        });

        undef $w, $cv->send if $call > 2;
    };

    $cv->recv;
}

ok 1;
done_testing;

BEGIN {
    package Foo;
    our $PACKAGE = 'MyDB';

    sub foo {
        my ($host, $port) = @_;
        $PACKAGE->connect($host, $port);
    }

    my $connection;
    sub foo_singleton {
        my ($host, $port) = @_;
        $connection ||= $PACKAGE->connect($host, $port);
    }



    package FooAny;
    our $PACKAGE = 'MyDB';

    sub foo {
        my ($host, $port, $cb) = @_;
        $PACKAGE->connect($host, $port, sub {
            my $conn = shift;
            $cb->($conn);
        });
    }

    my ($connection, @defers_cb, $in_connect);
    sub foo_singleton {
        my ($host, $port, $cb) = @_;
        
        return $cb->($connection) if $connection;
        if ($in_connect) {
            push @defers_cb, $cb;
            return;
        }

        $in_connect = 1;

        $PACKAGE->connect($host, $port, sub {
            my $conn = shift;
            $connection = $conn;
            $cb->($connection);

            $in_connect = 0;
            while (@defers_cb) {
                (shift @defers_cb)->($connection);
            }
        });
        return;
    }


    package MyDB;
    sub connect {
        my $class = shift;
        my ($host, $port, $cb) = @_;
        die 'cb must be coderef' if $cb && !(ref $cb eq 'CODE');

        say "$class constructor ", $cb ? 'async' : 'sync';
        bless my $self = {host => shift, port => shift}, $class;
        $cb->($self) if $cb;
        $self;
    }

    sub test {
        say "XXX test: @_";
    }
}

