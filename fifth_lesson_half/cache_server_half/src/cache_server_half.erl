-module(cache_server_half).

%% cache_server_half: cache_server_half library's entry point.
-include_lib("stdlib/include/ms_transform.hrl").
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).
-compile(export_all).


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() -> 
    gen_server:call(?MODULE, stop).

init([]) ->
    {ok, ets:new(?MODULE,[])}.

insert(Key, [H|T] = Value) ->
    gen_server:call(?MODULE, {insert, Key, Value}).

update(Key, Value) ->
    gen_server:call(?MODULE, {update, Key, Value}).

delete(Key) ->
    gen_server:call(?MODULE, {delete, Key}).

lookup(Key) ->
    gen_server:call(?MODULE, {lookup, Key}).

lookup_by_date(DateFrom, DateTo) ->
    gen_server:call(?MODULE, {lookdate, DateFrom, DateTo}).

handle_call({insert, Key, Value}, _From, Tab) ->
    ets:insert(Tab, {Key, Value, Datestamp = calendar:local_time()}),
    Reply = ok,
    {reply, Reply, Tab};

handle_call({update, Key, Value}, _From, Tab) ->
    ets:insert(Tab, {Key, Value, Datestamp = calendar:local_time()}),
    Reply = ok,
    {reply, Reply, Tab};

handle_call({delete, Key}, _From, Tab) ->
    ets:delete(Tab, Key),
    Reply = ok,
    {reply, Reply, Tab};

handle_call({lookup, InKey}, _From, Tab) ->
    %%Reply = ets:lookup(Tab, Key),
    MS = ets:fun2ms(fun({Key, Value, Datestamp}) 
        when Key == InKey ->
            [Value] end),
    Reply = {ok, ets:select(Tab, MS)}, 
    {reply, Reply, Tab};

handle_call({lookdate, DateFrom, DateTo}, _From, Tab) ->
    MS = ets:fun2ms(fun({Key, Value, Datestamp}) 
        when Datestamp >= DateFrom andalso Datestamp =< DateTo ->
            [Value] end),
    Reply = {ok, ets:select(Tab, MS)},    
    {reply, Reply, Tab};

handle_call(stop, _From, Tab) ->
    {stop, normal, stopped, Tab}.

handle_cast(_Msg, State) -> 
    {noreply, State}.
handle_info(_Info, State) -> 
    {noreply, State}.
terminate(_Reason, _State) -> 
    ok.
code_change(_OldVsn, State, Extra) -> 
    {ok, State}.

%% End of Module.
