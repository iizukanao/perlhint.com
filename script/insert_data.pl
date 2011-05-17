#!/usr/bin/env perl

use strict;
use warnings;
use FindBin::libs;

use PerlHint::Models;

my $file = shift or die "Usage: $0 <file>\n";
my $datafile = models('home')->file($file);
do $datafile or die $!;
