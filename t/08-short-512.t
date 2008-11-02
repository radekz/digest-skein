#!/usr/bin/perl -w
use strict;

chdir 't' if -e 't/testlib.pl';

require 'testlib.pl';

check_short(512);

