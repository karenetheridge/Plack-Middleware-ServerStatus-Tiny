use strict;
use warnings;
package Plack::Middleware::ServerStatus::Tiny;
# ABSTRACT: ...

use parent 'Plack::Middleware';
use Plack::Util::Accessor qw(path _uptime _access_count);

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

        my $res = Plack::Response->new('200');
        $res->content_type('text/plain');
        $res->content_length(length $content);
        $res->body($content);
        return $res->finalize;
    }

    $self->app->($env);
}

1;
__END__

=pod

=head1 SYNOPSIS

    use Plack::Middleware::ServerStatus::Tiny;

    ...

=head1 DESCRIPTION

...

=head1 FUNCTIONS/METHODS

=over 4

=item * C<foo>

...

=back

=head1 SUPPORT

=for stopwords irc

Bugs may be submitted through L<the RT bug tracker|https://rt.cpan.org/Public/Dist/Display.html?Name=Plack-Middleware-ServerStatus-Tiny>
(or L<bug-Plack-Middleware-ServerStatus-Tiny@rt.cpan.org|mailto:bug-Plack-Middleware-ServerStatus-Tiny@rt.cpan.org>).
I am also usually active on irc, as 'ether' at C<irc.perl.org>.

=head1 ACKNOWLEDGEMENTS

...

=head1 SEE ALSO

=begin :list

* L<foo>

=end :list

=cut
