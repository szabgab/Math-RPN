#!/usr/bin/perl
#
# @(#)Makefile.PL 1.8 01/07/29
# MakeMaker file for Math::RPN
#

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Math::RPN',
    'VERSION_FROM' => 'RPN.pm', # finds $VERSION
);
