package PerlHint;
use Ark;
use PerlHint::Models;

use_model 'PerlHint::Models';

use_plugins qw{
    Session
};

config 'Plugin::Session::Store::Model' => {
    model => 'cache',
};

config 'Plugin::Authentication::Store::Model' => {
    model => 'Schema::User',
};

config 'View::MT' => {
    macro => {
        models => \&models,
    },
};

__PACKAGE__->meta->make_immutable;
