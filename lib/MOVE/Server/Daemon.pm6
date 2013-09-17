use v6;

# https://github.com/mberends/http-server-simple/blob/master/examples/02-simple-small.pl6
use MOVE::HTTP::Request::Grammar;

class MOVE::Server::Daemon {
    has $.port;
    has $.host is rw;
    has IO::Socket::INET $!listener;
    has $.connection;   # returned by accept()
    #has Str $!request;
    #has Str @!headers;
    has Match $!parsed;

    class Output-Interceptor {
        has $.socket is rw;
        multi method print(*@a) {
            # $*ERR.say: "Intercepting print " ~ @a;
            $.socket.send(@a);
        }
        multi method say(*@a) {
            # $*ERR.say: "Intercepting say " ~ @a;
            $.socket.send(@a ~ "\x0D\x0A");
        }
    }

    method new ( $port=8080 ) {
        my %methods = self.^methods Z 1..*; # convert list to hash pairs
        self.bless( self.CREATE(), # self might also be a subclass
            port    => $port,
            host    => self.lookup_localhost,
        );
    }
    method lookup_localhost () {
        # should return this computer's "127.0.0.1" or somesuch
        #return 'localhost';
        return '0.0.0.0';
    }
    method run ( *@arguments ) { self.net_server(); }

    method net_server () {
        # an overrideable, minimal implementation called by run()
        say "{hhmm} ", self.WHAT, " started at {$!host}:{$!port}";
        self.setup_listener;
        self.after_setup_listener;
        while $!connection = $!listener.accept {
            self.accept_hook;
            # receive only one request per session - no keepalive yet
            my $received = $!connection.recv();
            $!parsed = MOVE::HTTP::Request::Grammar.parse($received);
            if $!parsed {
                # $*ERR.say: "Message parsed";
            } else {
                $*ERR.say: "Message not parsed: $received";
            }
            #self.setup(
            #    :method($method), # rakudobug RT
            #    protocol     => $protocol || 'HTTP/0.9',
            #    query_string => $query-string,
            #    request_uri  => $uri,
            #    path         => $path,
            #    localname    => $!host,
            #    localport    => $!port,
            #    peername     => 'NYI',
            #    peeraddr     => 'NYI',
            #);
            #self.headers( self.parse_headers() );
            $*ERR.say: "{hhmm} {$!parsed<resource>}";
            my $res = self.handler;
            #$!connection.close(); # client closes connection (error in chrome, might be because of keep-alive?)
        }
    }
    # Methods that a sub-class may want to override
    method handler () {
        # Called from net_server()
        # $*ERR.say: "in handler";
        my $stash-stdout = $*OUT;
        my Output-Interceptor $myIO .= new( socket => $!connection );
        $*OUT = $myIO;
        self.handle_request();
        $*OUT = $stash-stdout;
        # $*ERR.say: "end handler";
    }
    method handle_request () {
        # Called from handler()
        # $*ERR.say: "in handle_request";
        my $html = '';
        $html ~= "<html>\n<body>";
        $html ~= "MORE Server at {$.host}:{$.port}";
        $html ~= "<table border=\"1\">";
        for $!parsed<header> -> $header {
            $html ~= "<tr><td>{$header<header-name>}</td><td>{$header<header-value>}</td></tr>";
        }
        $html ~= "</table>";
        #$html ~= "Path: {$!path}<br/>";
        #$html ~= "Query string: {$!query_string}<br/>";
        $html ~= "</body>\n</html>";
        $html ~= "\r\n";

        print "HTTP/1.1 200 OK\r\n";
        print "Content-Type: text/html\r\n";
        print "Content-Length: {$html.chars}\r\n";
        print "\r\n";
        print $html;
        # $*ERR.say: "end handle_request";
    }
    method accept_hook () {
        # $*ERR.say: "accepted";
    }
    sub hhmm {
        my $seconds = floor(time) % 86400; # 24*60*60
        my $hhmm = floor($seconds/3600).fmt('%02d')
                 ~ floor(($seconds/60) % 60).fmt(':%02d');
        $hhmm;
    }
    method setup_listener () {
        # say "setup listener on port $!port";
        # PF_INET=2, SOCK_STREAM=1, TCP=6
        $!host //= '0.0.0.0'; # // confuses P5 syntax highlighters
        $!listener = IO::Socket::INET.new(
            :localhost($!host),
            :localport($!port),
            :listen,
        );
    }
    # Not Yet Implemented
    method background ( *@arguments ) { <...> }
    method restart () { <...> }
    method stdio_handle () { <...> }
    method stdin_handle () { <...> }
    method stdout_handle () { <...> }
    method after_setup_listener () { }
    method bad_request () { <...> }
}
