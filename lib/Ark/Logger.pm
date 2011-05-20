package Ark::Logger;
use Any::Moose;
use Cwd ();
use Path::Class ();
use Encode ();
use utf8;

has log_level => (
    is      => 'rw',
    isa     => 'Str',
    default => $ENV{ARK_DEBUG} ? 'debug' : 'error',
);

has file_log_level => (
    is      => 'rw',
    isa     => 'Str',
    default => 'info',
);

has log_levels => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub {
        {   debug => 4,
            info  => 3,
            warn  => 2,
            error => 1,
            fatal => 0,
        };
    },
);

no Any::Moose;

{
    no strict 'refs';
    my $pkg = __PACKAGE__;
    for my $level (qw/debug info warn error fatal/) {
        *{"${pkg}::${level}"} = sub {
            my ($self, $msg, $c, @args) = @_;
            print STDERR sprintf("[%s] %s\n", $level, Encode::encode('utf8', $msg), @args);
            # log to file if this log has importance that is more than or equal to info
            if ( $self->log_levels->{$level} <= $self->log_levels->{ $self->file_log_level } ) {
                my $logfile = Path::Class::file(Cwd::abs_path(__FILE__))
                                ->parent->parent->parent
                                ->subdir('tmp')->file('log');
                my $logmsg;
                if ($c) {
                    my $real_ip = $c->req->header('X-Forwarded-For');
                    unless ($real_ip) {
                        $real_ip = 'bare:' . $c->req->address;
                    }
                    my $referer = $c->req->referer;
                    unless (defined $referer) {
                        $referer = '';
                    }
                    $logmsg = (scalar localtime)." [$level] [$real_ip] $msg\tURL=".$c->req->uri."\tReferer=$referer\tUser-Agent=".$c->req->user_agent;
                } else {
                    $logmsg = sprintf("%s [%s] %s", scalar localtime, $level, $msg);
                }
                open my $io, '>>:encoding(utf8)', $logfile or return;
                print $io $logmsg . "\n";
                close $io;

            }
        };
    }
}

sub log {
    my ($self, $type, $msg, @args) = @_;

    return if !$self->log_levels->{$type}
        or $self->log_levels->{$type} > $self->log_levels->{ $self->log_level };

    print STDERR sprintf("[%s] ${msg}\n", $type, @args);
}

__PACKAGE__->meta->make_immutable;

