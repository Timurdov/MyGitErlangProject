-module(bs04).

%% bs04: bs04 library's entry point.
-export([decode_xml/1]).

decode_xml(Bin) ->
    Lastlist = decode_xml(Bin, 1, 0, 0, <<>>, <<>>,[],[]),
    if
        length(Lastlist) == 1 ->
            [Lasttuple] = Lastlist,
            Lasttuple;
        true ->Lastlist
    end.
decode_xml(<<"><", X,Rest/binary>>, Write, Level, Turnback, Accbin, Acclistbin, Acclist, Accbiglist) ->
    Levelrate = Level + 1,
    if
        Levelrate == 1 ->
            decode_xml(Rest, 1, Levelrate, Turnback, <<Accbin/binary, X>>, Acclistbin, Acclist, Accbiglist);
        true ->
            decode_xml(<<"</">>, 0, Levelrate, 1, Accbin, <<"Say, Hi!!!">>, decode_xml(<<"<", X,Rest/binary>>, 0, 0, 0, <<>>, <<>>, [], []), Accbiglist) 
     end;

decode_xml(<<"</", Rest/binary>>, Write, Level, Turnback, Accbin, Acclistbin, Acclist, Accbiglist) ->
    if 
        Turnback =/= 1 ->
            Bininlist = [Acclistbin | Acclist];
        true ->
            Bininlist = Acclist
    end,
    Plustolist = [{Accbin, [], Bininlist}|Accbiglist],
    Tagsize = bit_size(Accbin) + 8,
    Restsize = bit_size(<<Rest/binary>>),
    if
        Restsize > Tagsize ->
            decode_xml(<<Rest/binary>>, 0, Level-1, 0, <<>>, <<>>, Acclist, Plustolist);
        true -> 
            decode_xml(<<>>, 0, Level-1, 0, Accbin, Acclistbin, Bininlist, Plustolist)
    end;

decode_xml(<<"<", X,Rest/binary>>, Write, Level, Turnback, Accbin, Acclistbin, Acclist, Accbiglist) ->
    decode_xml(Rest, 1, 1, Turnback, <<Accbin/binary, X>>, Acclistbin, Acclist, Accbiglist);

decode_xml(<<">",X, Rest/binary>>, Write, Level, Turnback, Accbin, Acclistbin, Acclist, Accbiglist) ->
    decode_xml(Rest, 2, Level, Turnback, Accbin, <<Acclistbin/binary, X>>,Acclist, Accbiglist);

decode_xml(<<X,Rest/binary>>, Write, Level, Turnback, Accbin, Acclistbin, Acclist, Accbiglist) ->
    if 
        Write == 1 ->
            decode_xml(Rest, 1, Level, Turnback, <<Accbin/binary, X>>, Acclistbin, Acclist, Accbiglist);
        Write == 2 ->
            decode_xml(Rest, 2, Level, Turnback, Accbin, <<Acclistbin/binary, X>>,Acclist, Accbiglist);
        true -> decode_xml(Rest, 0, Level, Turnback, Accbin,Acclistbin, Acclist, Accbiglist)
    end;

decode_xml(<<>>, Write, Level, Turnback, Accbin, Acclistbin, Acclist, Accbiglist) ->
    lists:reverse(Accbiglist).


%% End of Module.
