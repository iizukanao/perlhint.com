package PerlHint::Context::ControllerUtils;
use Ark::Plugin;
use PerlHint::Models;

sub forward_404 {
    my ($self) = @_;

    $self->res->code(404);
    $self->res->body('Not Found');
    $self->detach;
}

sub forward_500 {
    my ($self) = @_;

    $self->res->code(500);
    $self->res->body('Internal Server Error');
    $self->detach;
}

1;
