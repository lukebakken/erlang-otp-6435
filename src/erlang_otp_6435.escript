#!/usr/bin/env escript
%% -*- erlang -*-
%%! -kernel logger_level debug

-include_lib("kernel/include/logger.hrl").

main([]) ->
    main(["tlsv1.3", "tlsv1.2"]);
main(Args) when is_list(Args) andalso length(Args) > 0 ->
    try
        ok = ssl:start(),
        TlsVersions = lists:map(fun erlang:list_to_existing_atom/1, Args),
        ?LOG_INFO("Using TLS versions: ~p", [TlsVersions]),
        Opts = [
                {versions, TlsVersions},
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
                        ?LOG_INFO("~p", [R]),
                        timer:sleep(500);
                    E0 ->
                        ?LOG_ERROR("~p", [E0]),
                        timer:sleep(500)
                end;
            E1 ->
                ?LOG_ERROR("~p", [E1]),
                timer:sleep(500)
        end,
        timer:sleep(1000),
        ?LOG_INFO("EXITING")
    catch
        Class:Error:Stack ->
            io:format(standard_error, "~p:~p~n~p~n", [Class, Error, Stack]),
            usage()
    end.

usage() ->
    io:format("usage: erlang_otp_6435 <tls versions>\n"),
    halt(1).
