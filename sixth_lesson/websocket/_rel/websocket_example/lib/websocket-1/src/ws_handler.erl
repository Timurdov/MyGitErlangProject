-module(ws_handler).
-export([init/2]).
-export([websocket_handle/3]).

init(Req, Opts) ->
        Opts,
	Table = ets:new(mytable,[ordered_set, named_table]),
	{cowboy_websocket, Req, Table}.

websocket_handle({text,  Msg}, Req, State) ->
        io:format("Msg = ~p~n",[Msg]),
        ByteAmount = 8*find_bytes(Msg, 0),
        <<Key:ByteAmount,",", Value/binary>> = Msg,
        if
            Value /= <<>> ->
                ets:insert(State,{Key, Value,calendar:local_time()});
            true ->
                Value
        end,
        [SomeList] = ets:lookup(State, Key),
        [Key, ThisValue,DateStamp] = tuple_to_list(SomeList),
        DateStamp,
	{reply, {text, <<ThisValue/binary>>}, Req, State};

websocket_handle(_Data, Req, State) ->
	{ok, Req, State}.

find_bytes(<<",", Rest/binary>>, Count) -> 
       Rest,
       Count;

find_bytes(<<X, Rest/binary>>, Count) -> 
       X,
       find_bytes(<<Rest/binary>>, Count+1).   

%%./_rel/websocket_example/bin/websocket_example console
