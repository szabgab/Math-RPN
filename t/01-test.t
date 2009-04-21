#!/usr/bin/perl
use strict;
use warnings;

use Test::More;

use Math::RPN;

#
# Tests are structured as a list.  Even numbered elements in the
# list are the expected result for the test expression contained
# in the next element in the list (odd numbered elements).
#
# Tests are numbered as n/2+2 where n is the list element number of the
# expected result in the list. (or int(n/2)+2 if n is the element number
# of the test, itself).
#

# Perl test numbers documented at right for debugging (Starts count
# from 1=did module load?), so @tests[0..1] is test 2, etc.
#
# did module load?						# 1
#
my @tests = (
#               [8]    [8][5] [40] [20] [2]     [64] [8]
	"8","5,3,+,  8,3,-     ,*,  2,/, 3,%, 6, POW, SQRT",	#  2
#	Get the SIN of 90 degrees (First convert 90 degrees to radians)
	"1","45,2,*,2,3.1415926,*,360,/,*,SIN",			#  3
#	Get the COS of 90 degrees
	"2.67948965850286e-08","45,2,*,2,3.1415926,*,360,/,*,COS", # 4
#	Test LOG and EXP
	"100","100,LOG,EXP",					#  5
#	Test Comparisons and simple IF
	"500","3,5,LT,500,0,IF",				#  6
	"300","4,4,LE,300,0,IF",				#  7
	"350","3,4,LE,350,0,IF",				#  8
	"400","5,3,LE,0,400,IF",				#  9
	"600","3,5,GT,0,600,IF",				# 10
	"700","5,3,GT,700,0,IF",				# 11
	"800","5,5,GE,800,0,IF",				# 12
	"900","6,3,NE,900,0,IF",				# 13
	"950","6,6,NE,0,950,IF",				# 14
#	Test Stack Manipulations
#	     (18/6-> 3 3 5->3 5->15 15 3->15 5->5 15->5 5 3->5 15->15)
	"15","6,18,EXCH,DIV,DUP,5,MAX,MUL,DUP,3,DIV,EXCH,POP,DUP,3,MUL,MAX",
								# 15
#	Complex IF (if with brace constructs)
	"6000","5,3,GT,{,10,20,30,*,*,},{,1,2,3,*,*,},IF",	# 17
	"6","5,3,LT,{,10,20,30,*,*,},{,1,2,3,*,*,},IF",		# 18

#	Functions added in version 1.05
	"5", "-5,ABS",						# 20
	"10", "5,++,++,++,++,++",				# 21
	"5", "10,--,--,--,--,--",				# 22
	"8", "24,40,&",						# 23
	"32", "48,96,AND",					# 24
	"5", "4,1,OR",						# 25
	"15", "10,5,|",						# 26
	"0", "5,!",						# 27
	"1", "0,NOT",						# 28
	"-3.38051500624659", "5,TAN",				# 29
	"5", "2.33242123,3.123123142312,+,INT",			# 30
#	"1", "4,5,xor",						# 33
	"0", "-1,~",						# 34
	"16384", "16384,~,~"					# 35
	
);

my %rand = (
	"RAND"      => "0<x<1",
	"100,LRAND" => "0<x<100",
);

plan tests => 1 + 2 * keys(%rand) + @tests/2;

is(rpn('TIME'), time, 'time???');

while (@tests) {
	my $expect = shift @tests;
	my $expr   = shift @tests;

	my $result = rpn($expr);

	# Factor rounding errors on different platforms out of results
	$expect = int($expect*10000+.5) / 10000;
	$result = int($result*10000+.5) / 10000;
	is $result, $expect;
}
foreach my $expr (keys %rand) {
	my $result = rpn($expr);

	my ($lower, $upper) = split /<x</, $rand{$expr};
	cmp_ok($result, '>', $lower);
	cmp_ok($result, '<', $upper);
}

