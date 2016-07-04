**Tecты**

Сделал Makefile для запуска всего, что понаписал. `make` - запустить все скрипты (сбилдить XS). Либо выборочно 
тоже можно, `make test1 [test2..test11]`.
Ниже продублировал основной код ответов.

**1**

- name: Асякин Андрей
- skype: `andrey_asyakin`
- phone: `8 985 423 0739`
- site: [linkedin](https://ru.linkedin.com/in/andreyasyakin)

**2**

130000

**3**

```perl
# в test_34.pl весь код для этого и 4 теста
# я так понял, что объект создается один? или все-же один для пары $host, $port.
# если второе, то $connection делам хешом просто.

my $connection;
sub foo_singleton {
    my ($host, $port) = @_;
    $connection ||= $PACKAGE->connect($host, $port);
}
```

**4**
```perl
my $connection;
sub foo_singleton {
    my ($host, $port, $cb) = @_;
    
    return $cb->($connection) if $connection;

    $PACKAGE->connect($host, $port, sub {
        my $conn = shift;
        $connection = $conn;
        $cb->($connection);
    });
    
    return;
}
```

**5**
```perl
# я так понял, здесь предполагается, что сроки только в байтовом виде, со сброшенным флагом
# тут можно также через unpack 'H2', pack 'C', но вроде без разницы
sub uri_escape {
    my $uri = shift;
    $uri =~ s/(.)/'%'.(sprintf '%02X', ord $1)/ge;
    $uri;
}
```

**6**
```perl
use Test::More;

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
```

**7**
```perl
my $ticks = shift || 1000;
$ticks    = 1000 if $ticks > 1000 || $ticks < 10;
my $tstep = 1 / $ticks;
my ($p3, $p7) = (int $ticks/3, int $ticks/7);

my $n = 0;
while () {
    select undef, undef, undef, $tstep;
    ++$n;
    if (not $n % $p3) {
        say "hello";
    }
    if (not $n % $p7) {
        say "world";
    }
}
```

**8**
```sql
SELECT u.*
FROM users u LEFT JOIN cards c ON u.user_id = c.user_id
WHERE c.user_id IS NULL;
```

**9**
```sql
SELECT u.* FROM users u JOIN 
    (SELECT user_id, count(*) FROM cards GROUP BY 1 HAVING count(*) > 1) c
ON u.user_id = c.user_id;
```

**10**
```C
const char *my_strstr(const char *where, const char *what) {
    const char *s;

    if (!where || !what)  return NULL;
    if (!*what)  return where;

    s = what;
    while (*where) {
        if (*where == *s) {
            while (*where && *where == *s) {
                ++where;
                ++s;
            }
            if (!*s)
                return where - (s - what);
            else {
                where -= s - what - 1;
                s = what;
            }
        }
        else 
            ++where;
    }

    return NULL;
}
```

**11**
```XS
# с XS, ну скажем так, поверхностно знаком

MODULE = StrLib           PACKAGE = StrLib

SV*
x_strstr(SV *where, SV *what)
    CODE:
    if (where == &PL_sv_undef || what == &PL_sv_undef) 
        XSRETURN_UNDEF;

    if (!SvPOK(where) || !SvPOK(what))
        croak("only string arguments allowed");

    SvGETMAGIC(where);
    SvGETMAGIC(what);

    const char *str = my_strstr(SvPV_nolen(where), SvPV_nolen(what));
    HV *hv = newHV();
    if (str) {
        hv_store(hv, "status", 6, newSVpv("ok", 2), 0);
        hv_store(hv, "found", 5, newSVpv(str, strlen(str)), 0);
        hv_store(hv, "source", 6, newSVsv(where), 0);
    }
    else {
        hv_store(hv, "status", 6, newSVpv("fail", 0), 0);
    }
    RETVAL = newRV_noinc((SV*)hv);
    OUTPUT:
    RETVAL
```
