package PerlHint::Controller::Root;
use Ark 'Controller';
use Plack::Builder;
use Plack::Middleware::Static;
use Plack::Request;
use PerlHint::Analyzer;
use File::Temp;
use Text::MicroTemplate qw(:all);
use Data::UUID;

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
    my $ret = PerlHint::Analyzer::analyze(\$code);

    $c->stash->{pre_code} = encoded_string($ret->{pre_code});
    $c->stash->{tip_code} = encoded_string($ret->{tip_code});
    $c->stash->{source} = encoded_string($ret->{source});
}

# ヒントパターン一覧表示
sub patterns :Local {
    my ($self, $c) = @_;

    $c->{stash}->{patterns} = PerlHint::Analyzer::patterns();
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
