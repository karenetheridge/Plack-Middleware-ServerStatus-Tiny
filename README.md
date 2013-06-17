# NAME

Plack::Middleware::ServerStatus::Tiny - tiny middleware for providing server status information

# VERSION

version 0.001

# SYNOPSIS

    use Plack::Builder;

    builder {
        enable 'ServerStatus::Tiny', path => '/status';
        $app;
    };

    $ curl http://server:port/status
    uptime: 120; access count: 10 (this process only)

# DESCRIPTION

This middleware is extremely lightweight: faster and smaller than
[Plack::Middleware::ServerStatus::Lite](http://search.cpan.org/perldoc?Plack::Middleware::ServerStatus::Lite). While that middleware is useful for
showing the status of all workers, their pids and their last requests, it can
be a bit heavy for frequent pinging (for example by a load balancer to confirm
that the server is still up).

This middleware does not use the disk, keeping all its data in memory in the
worker process.  All it returns is the number of seconds since the last server
restart, and how many requests this particular process has serviced.

# CONFIGURATION

- `path`

    The path which returns the server status.

# SUPPORT

Bugs may be submitted through [the RT bug tracker](https://rt.cpan.org/Public/Dist/Display.html?Name=Plack-Middleware-ServerStatus-Tiny)
(or [bug-Plack-Middleware-ServerStatus-Tiny@rt.cpan.org](mailto:bug-Plack-Middleware-ServerStatus-Tiny@rt.cpan.org)).
I am also usually active on irc, as 'ether' at `irc.perl.org`.

# SEE ALSO

- [Plack::Middleware::ServerStatus::Lite](http://search.cpan.org/perldoc?Plack::Middleware::ServerStatus::Lite)

# AUTHOR

Karen Etheridge <ether@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Karen Etheridge.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
