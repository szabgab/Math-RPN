use strict;
use warnings;

use Test::More;
use Test::Warn;

use Math::RPN;

plan tests => 2;

#	Should produce a stack underflow
my $result;
warning_like {$result = rpn("5,3,POP,POP,POP,5,3,*")} qr/err: Stack Underflow in 5,3,POP,POP,<<<POP>>>,5,3,\* at /;
is $result, undef;

