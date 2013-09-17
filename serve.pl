#!/usr/bin/env perl6
use v6;

# https://github.com/mberends/http-server-simple/blob/master/examples/02-simple-small.pl6
use MOVE::Server::Daemon;

#my MOVE::Server::Daemon $server .= new( 3100 );
#$server.run;
MOVE::Server::Daemon.new(3100).run;
