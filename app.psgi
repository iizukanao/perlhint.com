use lib qw(lib);
use Plack::Builder;
use Plack::Middleware::Static;
use PerlHint;

my $app = PerlHint->new;
$app->setup;

builder {
    enable 'Plack::Middleware::Static',
        path => qr{^/(js/|static/|css/|[^/]+\.[^/]+$)},
        root => $app->path_to('root')->stringify;

    $app->handler;
};
