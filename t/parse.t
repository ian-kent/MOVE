#!/usr/bin/env perl6
use v6;

use HTTP::Request::Grammar;

my @requests = (
    "GET /test HTTP/1.1\nContent-Type: text/plain",
    "GET /test.html HTTP/1.1\nContent-Type: text/plain",
    "POST /transaction/create HTTP/1.1\nContent-Type: text/plain\n\n\{ foo: 'bar' \}\n",
    "POST /transaction/create HTTP/1.1\nContent-Type: text/json\n\ntest",
);

for @requests -> $request {
    say "Trying '$request'";
    my $match = HTTP::Request::Grammar.parse($request);
    if $match {
        say " Matched";
        say "  Method: {$match<method>}";
        say "  Resource: {$match<resource>}";
        say "  Version: {$match<version>}";
        say "  Headers:";
        for $match<headers> -> $header {
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
