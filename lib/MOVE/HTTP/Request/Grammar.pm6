use v6;

grammar MOVE::HTTP::Request::Grammar {
    rule TOP { 
        ^
        <method> <resource> 'HTTP/'<version>
        <headers>+
        <body>?
        $
    }
    token method {
        'GET' | 'POST' | 'PUT' | 'DELETE' | 'OPTIONS' | 'HEAD' | 'TRACE' | 'CONNECT' | 'PATCH'
    }
    token resource {
        ('/' | '.' | <alpha>)+
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
    rule body {
        .*
    }
}
