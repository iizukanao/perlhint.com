package PerlHint::Form::Pattern;
use Ark '+PerlHint::Form';

my $MAX_LENGTH = 255;

param name => (
    type   => 'TextField',
    widget => 'input',
    label  => 'パターン名',
    required => 1,
    class => 'test',
    custom_validation => sub {
        my ($self, $form, $field) = @_;

        my $val = $form->param($field->name);
        if ($val) {
            if ( length($val) > $MAX_LENGTH ) {
                $form->set_error($field->name, 'too_long');
            } elsif ( $val =~ /[^a-zA-Z0-9_-]/ ) {
                $form->set_error($field->name, 'invalid_char');
            }
        }
    },
);

param pattern => (
    type   => 'TextField',
    widget => 'input',
    label  => 'パターンの正規表現',
    required => 1,
);

param description => (
    type   => 'TextField',
    widget => 'input',
    label  => '解説',
    required => 1,
);

__PACKAGE__->meta->make_immutable;

1;
