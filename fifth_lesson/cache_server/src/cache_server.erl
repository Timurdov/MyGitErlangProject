-module(cache_server).

%% cache_server: cache_server library's entry point.

-include_lib("stdlib/include/ms_transform.hrl").
-behaviour(gen_server).
-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).
-compile(export_all).


start_link(TtoLive) ->
    TTL = proplists:get_value(ttl, TtoLive),
    gen_server:start_link({local, ?MODULE}, ?MODULE, TTL, []).

stop() -> 
    gen_server:call(?MODULE, stop).

init(TTL) ->
    Tab = ets:new(?MODULE,[ordered_set, named_table]),
    DeleteTime = TTL*1000,
    Timer = erlang:send_after(DeleteTime, self(), ttl),
    {ok, {Tab,Timer,TTL}}.

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

handle_call({insert, Key, Value}, _From, {Tab,Timer,TTL}) ->
    Datestamp = calendar:local_time(),
    BaseDate = calendar:datetime_to_gregorian_seconds(Datestamp),
    AllSeconds = BaseDate + TTL,
    EndDate = calendar:gregorian_seconds_to_datetime(AllSeconds),
    ets:insert(Tab, {Key, Value, Datestamp, EndDate}),
    Reply = ok,
    {reply, Reply, {Tab,Timer,TTL}};

handle_call({update, Key, Value}, _From, {Tab,Timer,TTL}) ->
    Datestamp = calendar:local_time(),
    BaseDate = calendar:datetime_to_gregorian_seconds(Datestamp),
    AllSeconds = BaseDate + TTL,
    EndDate = calendar:gregorian_seconds_to_datetime(AllSeconds),
    ets:insert(Tab, {Key, Value, Datestamp, EndDate}),
    Reply = ok,
    {reply, Reply, {Tab,Timer,TTL}};

handle_call({delete, Key}, _From, {Tab,Timer,TTL}) ->
    ets:delete(Tab, Key),
    Reply = ok,
    {reply, Reply, {Tab,Timer,TTL}};

handle_call({lookup, Key}, _From, {Tab,Timer,TTL}) ->
    Reply = ets:lookup(Tab, Key),
    {reply, Reply, {Tab,Timer,TTL}};

handle_call({lookdate, DateFrom, DateTo}, _From, {Tab,Timer,TTL}) ->
    MS = ets:fun2ms(fun({Key, Value, Datestamp, EndDate}) 
        when Datestamp >= DateFrom andalso Datestamp =< DateTo ->
            [Value] end),
    Reply = {ok, ets:select(Tab, MS)},    
    {reply, Reply, {Tab,Timer,TTL}};

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State}.

handle_cast(_Msg, State) -> 
    {noreply, State}.

handle_info(ttl, {Tab,OldTimer,TTL}) ->  
    erlang:cancel_timer(OldTimer),
    First = ets:first(Tab),
    delete_item(First, Tab),
    Timer = erlang:send_after(1000, self(), ttl),   
    {noreply, {Tab,Timer,TTL}}.

terminate(_Reason, _State) -> 
    ok.

code_change(_OldVsn, State, Extra) -> 
    {ok, State}.

delete_item('$end_of_table', Tab) ->
    ok;

delete_item(Item, Tab) ->
     NowDate = calendar:local_time(),
     [{_,_,_, EndDate}] = ets:lookup(Tab, Item),
     if
         NowDate > EndDate ->
             ets:delete(Tab, Item),
             Next = ets:next(Tab, Item);
         true ->
             Next = '$end_of_table'
     end,     
     delete_item(Next, Tab).

%% End of Module.
