#!/usr/bin/env perl6
use v6;

use MOVE::HTTP::Request::Grammar;

my @requests = (
    "GET /test HTTP/1.1\nContent-Type: text/plain",
    "GET /test.html HTTP/1.1\nContent-Type: text/plain",
    "POST /transaction/create HTTP/1.1\nContent-Type: text/plain\n\n\{ foo: 'bar' \}\n",
    "POST /transaction/create HTTP/1.1\nContent-Type: text/json\n\ntest",
    "GET /whatever?name=value HTTP/1.1\nContent-Type: text/json\n\ntest",
    "GET /whatever?name=value HTTP/1.1\nHost: 192.168.100.2:3100\nConnection: keep-alive\nCache-Control: max-age=0\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nUser-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTM",
);

for @requests -> $request {
    say "Trying '$request'";
    my $match = MOVE::HTTP::Request::Grammar.parse($request);
    if $match {
        say " Matched";
        say "  Method: {$match<method>}";
        say "  Resource: {$match<resource>}";
        say "  URI: {$match<resource><uri>}";
        say "  Query String: {$match<resource><query-string>}";
        say "  Version: {$match<version>}";
        say "  Headers:";
        for $match<header> -> $header {
            say "   {$header<header-name>}: {$header<header-value>}";
        }
        if $match<body>.trim {
            say "  Body:";
            say "   {$match<body>}";
        }
    } else {
        say " Not matched";
    }
    say;
}
