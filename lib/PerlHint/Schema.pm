package PerlHint::Schema;
use strict;
use warnings;
use base qw/DBIx::Class::Schema/;

our $VERSION = '2';

use DateTime;
use DateTime::TimeZone;
use PerlHint::Models;

__PACKAGE__->load_namespaces;

unless (models('conf')->{database}->{enable_replicated}) {
    __PACKAGE__->load_components(qw/Schema::Versioned/);
    __PACKAGE__->upgrade_directory('sql/');
}

{
    my $TZ = DateTime::TimeZone->new( name => 'UTC' );
    sub TZ { $TZ }
}

1;
