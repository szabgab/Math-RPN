use strict;
use warnings;

use Test::More;
use Test::Warn;


use Math::RPN;

plan tests => 1 + 4;

#	Should produce a stack underflow
my $result;
warning_like {$result = rpn("5,3,POP,POP,POP,5,3,*")} qr/err: Stack Underflow in 5,3,POP,POP,<<<POP>>>,5,3,\* at /;
is $result, undef;


warning_like {$result = rpn("9,3,2,+")} qr/ warning: Extra values left on stack for expr 9,3,2,\+ left 9,5 \(right one used\)\. at/;
is $result, 5;

my @result = rpn("9,3,2,+");
is_deeply \@result, [9, 5], 'stack overflow in array context';


#warning_like {$result = rpn("5,3,{,{,2,1,=")} qr/xxx/;
#is $result, undef;
