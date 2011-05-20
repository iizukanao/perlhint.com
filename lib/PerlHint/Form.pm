package PerlHint::Form;
use strict;
use warnings;
use Ark 'Form';

use PerlHint::Form::Widget;

widgets 'PerlHint::Form::Widget';

sub render {
    my ($self, $name) = @_;
    return $self->_shakan->render unless $name;
    my $res = ($self->label($name) || '')
            . ($self->input($name) || '')
            . ($self->error_message($name) || '');
}

sub messages {
    my $self = shift;

    return {
        not_null => '[_1]を入力してください',
        too_long => '[_1]が長すぎます (255文字以下)',
        invalid_char => '使えない文字が含まれています',
        map({ $_ => '[_1] is invalid' } qw/
                date duplication length regex
                / ),
        %{ $self->_fields_messages },
    };
}

__PACKAGE__->meta->make_immutable;

1;
