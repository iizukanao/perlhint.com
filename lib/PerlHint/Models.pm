package PerlHint::Models;
use Ark::Models '-base';

register Schema => sub {
    my $self = shift;

    my $conf = $self->get('conf')->{database}
        or die 'require database config';

    $self->ensure_class_loaded('PerlHint::Schema');
    PerlHint::Schema->connect(@$conf);
};

for my $table (qw/User/) {
    register "Schema::${table}" => sub {
        shift->get('Schema')->resultset($table);
    };
}

register cache => sub {
    my $self = shift;

    my $conf = $self->get('conf')->{cache}
        or die 'require cache config';

    $self->ensure_class_loaded('Cache::FastMmap');
    Cache::FastMmap->new(%$conf);
};

1;
