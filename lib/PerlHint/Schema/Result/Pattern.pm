package PerlHint::Schema::Result::Pattern;
use strict;
use warnings;
use base 'PerlHint::Schema::ResultBase';

use PerlHint::Models;
use DateTime;

__PACKAGE__->table('pattern');

__PACKAGE__->add_columns(
    id => {
        data_type => 'INTEGER',
        is_nullable => 0,
        is_auto_increment => 1,
        extra => {
            unsigned => 1,
        },
    },

    name => {
        data_type   => 'VARCHAR',
        size        => 255,
        is_nullable => 0,
    },

    pattern => {
        data_type   => 'TEXT',
        is_nullable => 1,
    },

    description => {
        data_type   => 'TEXT',
        is_nullable => 1,
    },

    created_date => {
        data_type   => 'DATETIME',
        is_nullable => 0,
        timezone    => __PACKAGE__->default_time_zone,
    },

    updated_date => {
        data_type   => 'DATETIME',
        is_nullable => 0,
        timezone    => __PACKAGE__->default_time_zone,
    },
);

__PACKAGE__->set_primary_key('id');

sub insert {
    my $self = shift;

    my $now = DateTime->now;
    $self->created_date($now);
    $self->updated_date($now);

    $self->next::method(@_);
}

sub update {
    my $self = shift;

    $self->updated_date(DateTime->now);
    $self->next::method(@_);
}

1;
