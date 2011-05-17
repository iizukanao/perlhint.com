package PerlHint::Schema::ResultBase;
use strict;
use warnings;
use base 'DBIx::Class';

use DateTime::TimeZone;

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);

sub default_time_zone { PerlHint::Schema->TZ }

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;

    $sqlt_table->extra(
        mysql_table_type => 'InnoDB',
        mysql_charset    => 'utf8',
    );
}

1;
