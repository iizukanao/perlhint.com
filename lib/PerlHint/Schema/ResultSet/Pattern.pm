package PerlHint::Schema::ResultSet::Pattern;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

use PerlHint::Models;

sub get_all_patterns {
    my ($self) = @_;

    my $pattern;
    my %patterns;
    my $rs = $self->search;
    while ($pattern = $rs->next) {
        $patterns{$pattern->name} = {
            id          => $pattern->id,
            pattern     => $pattern->pattern,
            description => $pattern->description,
        };
    }
    return \%patterns;
}

1;
