

all : test1 test2 test3 test4 test5 test6 test7 test8 test9 test10 test11


test1 ::
	perl test_12.pl 1

test2 ::
	perl test_12.pl 2

test3 ::
	perl test_34.pl 3 

test4 ::
	perl test_34.pl 4


test5 ::
	perl test_5.pl

test6 ::
	perl test_6.pl

test7 ::
	perl test_7.pl


test8 ::
	cat test_89.sql

test9 ::
	cat test_89.sql

test10 :: 
	@echo =====================
	@echo test_10 build and run
	@echo =====================
	@cc -Wall -std=c99 -o test10 test_10.c my_strstr.c
	./test10 'Hello, world' world
	./test10 'Hello, world' o

test11 :: 
	@echo =====================
	@echo test_11 build and run
	@echo =====================
	@sh -c 'cd StrLib; [ -e Makefile ] && make clean > /dev/null 2>&1; \
		perl Makefile.PL && make >/dev/null; \
		perl -Iblib/lib -Iblib/arch t/010-strstr.t'

