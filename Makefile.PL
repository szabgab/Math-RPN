#!/usr/bin/perl
use strict;
use warnings;

use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Math::RPN',
    'VERSION_FROM' => 'lib/Math/RPN.pm',
);
