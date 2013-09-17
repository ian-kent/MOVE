use v6;

grammar MOVE::HTTP::Request::Grammar {
    rule TOP { 
        ^
        <method> <resource> 'HTTP/'<version>
        <header>+
        <body>?
        $
    }
    token method {
        'GET' | 'POST' | 'PUT' | 'DELETE' | 'OPTIONS' | 'HEAD' | 'TRACE' | 'CONNECT' | 'PATCH'
    }
    regex resource {
        <uri> <query-string>?
    }
    regex uri {
        <-[\s\?]>+
    }
    regex query-string {
        '?' \S+
    }
    token version {
        <digit>+ '.' <digit>+
    }
    rule header {
        <header-name> ':' <header-value>
    }
    token header-name {
        <-[:]>+
    }
    token header-value {
        <-[\n]>+
    }
    rule body {
        .*
    }
}
