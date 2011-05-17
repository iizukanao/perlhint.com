package PerlHint::Models;
use Ark::Models '-base';
use Module::Find;
use Object::Container;

Object::Container->register('PerlHint::Analyzer');

register Schema => sub {
    my $self = shift;

    my $dbconf = $self->get('conf')->{database};
    my $enable_replicated = $dbconf->{enable_replicated};
    my $master = $dbconf->{master}
        or die "master database config is required inside config.pl";
    my $slaves = $dbconf->{slave};

    $self->ensure_class_loaded('PerlHint::Schema');

    my $schema = PerlHint::Schema->clone;
    if ($enable_replicated) {
        $schema->storage_type([
            '::DBI::Replicated' => {
                balancer_type => '::Random',
                balancer_args => {
                    auto_validate_every => 5,
                },
                pool_args => {
                    maximum_lag => 2,
                },
            }
        ]);
    }

    $schema->connection(@$master);
    if ($enable_replicated) {
        $schema->storage->connect_replicants(@$slaves);
    }

    $schema->default_resultset_attributes({
        cache_object => $self->get('schema_cache'),
    });

    $schema;
};

{
    my @modules = Module::Find::findallmod('PerlHint::Schema::Result');
    my %module_by_name = map {
        my $module = $_;
        (my $name = $module) =~ s/PerlHint::Schema::Result:://;
        $name => $module;
    } @modules;

    for my $source (keys %module_by_name) {
        register "Schema::${source}" => sub {
            shift->get('Schema')->resultset($source);
        };
    }
}

register cache => sub {
    my $self = shift;

    my $conf = $self->get('conf')->{cache}
        or die 'config.pl: cache config is required';

    $self->adaptor($conf);
};

register schema_cache => sub {
    my $self = shift;

    my $conf = $self->get('conf')->{schema_cache}
        or die "Require schema_cache config";

    $self->adaptor($conf);
};

register json => sub {
    my $self = shift;
    $self->ensure_class_loaded('JSON::XS');
    JSON::XS->new->utf8;
};

1;
