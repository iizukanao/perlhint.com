package PerlHint::Schema::ResultBase;
use strict;
use warnings;
use base 'DBIx::Class';

use DateTime::TimeZone;

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);

our $TZ = DateTime::TimeZone->new( name => 'Asia/Tokyo' );

sub default_time_zone { $TZ }

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;

    $sqlt_table->extra(
        mysql_table_type => 'InnoDB',
        mysql_charset    => 'utf8',
    );
}

1;

