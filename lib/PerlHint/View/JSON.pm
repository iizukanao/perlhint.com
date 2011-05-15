package PerlHint::View::JSON;
use Ark 'View::JSON';

has '+expose_stash' => default => 'json';

__PACKAGE__->meta->make_immutable;
