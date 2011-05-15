#!/usr/bin/env perl

use strict;
use warnings;
use FindBin::libs;

use PerlHint::Models;

my $sql = models('home')->subdir(qw/sql fixtures/)->file('default.pl');
do $sql or die $!;


