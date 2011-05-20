package PerlHint::Controller::Root;
use Ark 'Controller';

has '+namespace' => default => '';

sub default :Path :Args {
    my ($self, $c) = @_;

    $c->res->status(404);
    $c->view('MT')->template('errors/404');
}

# トップ
sub index :Path {
    my ($self, $c) = @_;
}

# POST -> ヒント表示
sub hint :Local {
    my ($self, $c) = @_;

    my $code = $c->req->param('code');
    my $ret = Object::Container->get('PerlHint::Analyzer')->analyze(\$code);

    $c->stash->{pre_code} = $ret->{pre_code};
    $c->stash->{tip_code} = $ret->{tip_code};
    $c->stash->{source} = $ret->{source};
}

sub end :Private {
    my ($self, $c) = @_;

    $c->res->header('Cache-Control' => 'no-cache');
    $c->res->header('Pragma' => 'no-cache');
    $c->res->header('Content-Type' => 'text/html; charset=UTF-8');

    unless ($c->res->body or $c->res->status =~ /^3\d\d/) {
        $c->forward( $c->view('MT') );
    }
}

__PACKAGE__->meta->make_immutable;
