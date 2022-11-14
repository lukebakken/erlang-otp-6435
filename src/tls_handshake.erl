-module(tls_handshake).

-export([start/0]).

start() ->
    ssl:start(),
    Opts = [
            {cacertfile, "./certs/rootCA.pem"},
            {certfile,   "./certs/cert.pem"},
            {keyfile,    "./certs/key.pem"},
            {verify, verify_peer},
            {fail_if_no_peer_cert, true},
            {certificate_authorities, false},
            {log_level, debug}
           ],
    {ok, ListenSocket} = ssl:listen(9999, Opts),
    {ok, TLSTransportSocket} = ssl:transport_accept(ListenSocket),
    {ok, _} = ssl:handshake(TLSTransportSocket),
    ok.
