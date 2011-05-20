package PerlHint::Form::Widget;
use strict;
use warnings;
use utf8;
use base 'HTML::Shakan::Widgets::Simple';

use HTML::Shakan::Utils;

sub _attr {
    my $attr = shift;

    my @ret;

    for my $key (sort keys %$attr) {
        push @ret, sprintf(q{%s="%s"}, encode_entities($key), encode_entities($attr->{$key}));
    }
    join ' ', @ret;
}

sub widget_input {
    my ($self, $form, $field) = @_;

    if (my $value = $form->fillin_param($field->{name})) {
        $field->value($value);
    }

    return '<input ' . _attr($field->attr) . " />";
}

sub widget_radio {
    my ($self, $form, $field) = @_;

    my $choices = delete $field->{choices};
    my $value = $form->fillin_param($field->{name});
    my @t;
    while (my ($v, $l) = splice @$choices, 0, 2) {
        push @t, sprintf(
            '<input type="radio" name="%s" value="%s"%s />%s　',
            encode_entities($field->{name}),
            encode_entities($v),
            (($value eq '0' && $v eq '0') || ($value && $value eq $v) ? ' checked' : ''),
            encode_entities($l),
        );
    }

    $t[-1] =~ s/　$//;
    return join q[], @t;
}

1;
