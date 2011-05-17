package PerlHint;
use Ark;
use PerlHint::Models;
use Lingua::EN::Inflect;

use_model 'PerlHint::Models';

use_plugins qw{
    Session
    Session::Store::Model
};

our $VERSION = '0.01';

config 'View::MT' => {
    use_cache => 1,
    macro => {
        models => \&models,
        encoding => sub {
            __PACKAGE__->context->encoding(@_);
        },
        uri_for => sub {
            __PACKAGE__->context->uri_for(@_);
        },
        link_for => sub {
            __PACKAGE__->context->link_for(@_);
        },
        stash => sub {
            __PACKAGE__->context->stash;
        },
        PL => sub {
            Lingua::EN::Inflect::PL(@_);
        }
    },
};

config 'Plugin::Session::Store::Model' => {
    model => 'cache',
};

config 'Plugin::PageCache' => {
    model => 'cache',
};

config 'Plugin::Session' => {
    expires => '+30d',
};

config 'Plugin::Session::State::Cookie' => {
    cookie_name => 'k-sid',
};

__PACKAGE__->meta->make_immutable;
