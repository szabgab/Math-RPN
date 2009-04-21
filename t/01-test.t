#!/usr/bin/perl
use strict;
use warnings;

use Test::More;

use Math::RPN;

my %tests = (
	"5,3,+,  8,3,-     ,*,  2,/, 3,%, 6, POW, SQRT" => 8,

#	Get the SIN of 90 degrees (First convert 90 degrees to radians)
	"45,2,*,2,3.1415926,*,360,/,*,SIN" => 1,
#	Get the COS of 90 degrees
	"45,2,*,2,3.1415926,*,360,/,*,COS" => "2.67948965850286e-08",
#	Test LOG and EXP
	"100,LOG,EXP" => 100,
#	Test Comparisons and simple IF
	"3,5,LT,500,0,IF" => 500,
	"4,4,LE,300,0,IF" => 300,
	"3,4,LE,350,0,IF" => 350,
	"5,3,LE,0,400,IF" => 400,
	"3,5,GT,0,600,IF" => 600,
	"5,3,GT,700,0,IF" => 700,
	"5,5,GE,800,0,IF" => 800,
	"6,3,NE,900,0,IF" => 900,
	"6,6,NE,0,950,IF" => 950,

#	Test Stack Manipulations
#	     (18/6-> 3 3 5->3 5->15 15 3->15 5->5 15->5 5 3->5 15->15)
	"6,18,EXCH,DIV,DUP,5,MAX,MUL,DUP,3,DIV,EXCH,POP,DUP,3,MUL,MAX" => 15,
#	Complex IF (if with brace constructs)
	"5,3,GT,{,10,20,30,*,*,},{,1,2,3,*,*,},IF" => 6000,
	"5,3,LT,{,10,20,30,*,*,},{,1,2,3,*,*,},IF" => 6,

#	Functions added in version 1.05
	"-5,ABS" => 5,
	"5,++,++,++,++,++" => 10,
	"10,--,--,--,--,--" => 5,
	"24,40,&" => 8,
	"48,96,AND" => 32,
	"4,1,OR" => 5,
	"10,5,|" => 15,
	"5,!" => 0,
	"0,NOT" => 1,
	"5,TAN" => "-3.38051500624659",
	"2.33242123,3.123123142312,+,INT" => 5,
#	"4,5,xor" => 1,
	"-1,~" => 0,
	"16384,~,~" => 16384,
	
);

my %rand = (
	"RAND"      => "0<x<1",
	"100,LRAND" => "0<x<100",
);

plan tests => 1 + 2 * keys(%rand) + keys %tests;

is(rpn('TIME'), time, 'time???');

foreach my $expr (sort keys %tests) {
	my $expect = $tests{$expr};
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

