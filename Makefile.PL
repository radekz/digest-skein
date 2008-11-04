#!/usr/bin/perl -w
use strict;
use 5.008000;
use ExtUtils::MakeMaker;
WriteMakefile(
	NAME          => 'Digest::Skein',
	VERSION_FROM  => 'lib/Digest/Skein.pm',
	PREREQ_PM     => { 'Test::More' => 0, },
	ABSTRACT_FROM => 'lib/Digest/Skein.pm',
	AUTHOR        => 'Radoslaw Zielinski <radek@pld-linux.org',
##	DEFINE        => '',
	clean         => { FILES => 'Optimized_64bit/*.o', },
);

sub MY::postamble {
	'
LDFROM += Optimized_64bit/*.o
'
}
