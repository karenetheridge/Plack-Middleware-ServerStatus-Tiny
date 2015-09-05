use strict;
use warnings;
package Plack::Middleware::ServerStatus::Tiny;
# ABSTRACT: Tiny middleware for providing server status information
# KEYWORDS: plack middleware status console debugging monitoring uptime access counter
# vim: set ts=8 sts=4 sw=4 tw=115 et :

our $VERSION = '0.003';

use parent 'Plack::Middleware';
use Plack::Util::Accessor qw(path _uptime _access_count);
use Plack::Response;

sub prepare_app
{
    my $self = shift;

    die 'missing required option: \'path\'' if not $self->path;
    warn 'path "' . $self->path . '" does not begin with /, and will never match' if $self->path !~ m{^/};

    $self->_uptime(time);
    $self->_access_count(0);
}

sub call
{
    my ($self, $env) = @_;

    $self->_access_count($self->_access_count + 1);

    if ($env->{PATH_INFO} eq $self->path)
    {
        my $content = 'uptime: ' . (time - $self->_uptime)
            . '; access count: ' . $self->_access_count;

        my $res = Plack::Response->new(
            '200',
            { content_type => 'text/plain', content_length => length $content },
            $content,
        );

        return $res->finalize;
    }

    $self->app->($env);
}

1;
__END__

=pod

=head1 SYNOPSIS

    use Plack::Builder;

    builder {
        enable 'ServerStatus::Tiny', path => '/status';
        $app;
    };

    $ curl http://server:port/status
    uptime: 120; access count: 10

=head1 DESCRIPTION

=for stopwords balancer pids

This middleware is extremely lightweight: faster and smaller than
L<Plack::Middleware::ServerStatus::Lite>. While that middleware is useful for
showing the status of all workers, their pids and their last requests, it can
be a bit heavy for frequent pinging (for example by a load balancer to confirm
that the server is still up).

This middleware does not interrogate the system about running processes,
and does not use the disk, keeping all its data in memory in the
worker process. All it returns is the number of seconds since the last server
restart, and how many requests this particular process has serviced.

=head1 CONFIGURATION

=head2 C<path>

The path which returns the server status. This is required; there is no default.

=head1 SEE ALSO

=for :list
* L<Plack::Middleware::ServerStatus::Lite>
* L<Plack::Middleware>
* L<Plack::Builder>

=cut
