#!/usr/bin/env perl6
use v6;

grammar HTTP {
    rule TOP { 
        ^
        <method> <url> <http>
        <headers>+
        $
    }
    token method {
        'GET' | 'POST' | 'PUT' | 'DELETE' | 'OPTIONS'
    }
    token url {
        ('/' | <alpha>)+
    }
    rule http {
        'HTTP/' <version>
    }
    token version {
        <digit>+ '.' <digit>+
    }
    rule headers {
        <header-name> ':' <header-value>
    }
    token header-name {
        (<alpha> | '-')+
    }
    token header-value {
        (<alpha> | '/')+
    }
}

my $request = q:to /EOS/; 
GET /test HTTP/1.1
Content-Type: text/plain
EOS

my $match = HTTP.parse($request);
if $match {
    say "Matched";
    say "  Method: {$match<method>}";
    say "  URL: {$match<url>}";
    say "  HTTP: {$match<http><version>}";
    say "  Headers:";
    for $match<headers> -> $header {
        say "    {$header<header-name>}: {$header<header-value>}";
    }
}
