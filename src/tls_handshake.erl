-module(tls_handshake).

-export([start/0]).

-include_lib("kernel/include/logger.hrl").

start() ->
    ok = ssl:start(),
    Opts = [
            % Note: the following results in a different error
            % {versions, ['tlsv1.3', 'tlsv1.2']},
            {versions, ['tlsv1.3']},
            {cacertfile, "./certs/rootCA.pem"},
            {certfile, "./certs/cert.pem"},
            {keyfile, "./certs/key.pem"},
            {depth, 10},
            {reuseaddr, true},
            {verify, verify_peer},
            {fail_if_no_peer_cert, true},
            {log_level, debug}
           ],
    {ok, ListenSocket} = ssl:listen(9999, Opts),
    case ssl:transport_accept(ListenSocket) of
        {ok, TLSTransportSocket} ->
            case ssl:handshake(TLSTransportSocket) of
                {ok, _}=R ->
                    ?LOG_INFO("~p", [R]);
                E0 ->
                    ?LOG_ERROR("~p", [E0])
            end;
        E1 ->
            ?LOG_ERROR("~p", [E1])
    end,
    ok = init:stop().
