-module(myapi2).

%% myapi2: myapi2 library's entry point.

-compile([export_all]).
-include_lib("stdlib/include/ms_transform.hrl").

create_new_table(Tablename) ->
    Tablename = ets:new(Tablename, [set, named_table]).

add_new_record(Tablename, Key, [H|T]=Param) ->
   ets:insert(Tablename, {Key, Param, Datestamp = erlang:localtime()}).

update_record(Tablename, Key, [H|T]=Param) ->
   ets:insert(Tablename, {Key, Param, Datestamp = erlang:localtime()}).

find_record(Tablename, Key) ->
    ets:lookup(Tablename, Key).

find_by_daterange(Tablename, Y1, M1, D1, Hour1, Min1, Sec1, Y2, M2, D2, Hour2, Min2, Sec2) -> 
    Date1 = {{Y1, M1, D1},{Hour1, Min1, Sec1}},
    Date2 = {{Y2, M2, D2}, {Hour2, Min2, Sec2}},
    MS = ets:fun2ms(fun({Key, Param, Datestamp}) 
        when Datestamp > Date1 andalso Datestamp < Date2 ->
            [Key, Param, Datestamp] end),
    ets:select(Tablename, MS).


delete_record(Tablename, Key) ->
    ets:delete(Tablename, Key).

delete_table(Tablename) ->
    ets:delete(Tablename).


%%-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

myapi2_test_()->[
	?_assertEqual(first, create_new_table(first)),
	?_assertEqual(true, add_new_record(first, 1, ['Tim', 'Dou', 'skype60'])),
	?_assertEqual([{1, ['Tim', 'Dou', skype60], erlang:localtime()}], find_record(first, 1)),
	?_assertEqual(true, update_record(first, 1, ['Tom', 'Johnson', skype64])),
	?_assertEqual([{1, ['Tom', 'Johnson', skype64], erlang:localtime()}], find_record(first, 1)),
	?_assertEqual([[1, ['Tom', 'Johnson', skype64], erlang:localtime()]], find_by_daterange(first, 2011,9,9,0,0,0,2017,2,2,12,30,21)),
	?_assertEqual(true, delete_record(first, 1)),
	?_assertEqual([], find_record(first, 1)),
	?_assertEqual(true, delete_table(first))].
%%-endif.


%% End of Module.
