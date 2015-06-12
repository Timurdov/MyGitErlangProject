-module(myapi).

%% myapi: myapi library's entry point.

-export([create_new_group/1, add_new_student/5, update_student/6, delete_student/2]).
-export([find_student/2, find_by_date/4, find_by_daterange/7, delete_group/1]).
%%-compile([export_all]).
-include_lib("stdlib/include/ms_transform.hrl").


create_new_group(Tablename) ->
    Tablename = ets:new(Tablename, [set, named_table]).

add_new_student(Tablename, Id, Name, Lastname, Skype) ->
   Idtest = test_value(Id),
    if
        Idtest == true ->
             Testid = find_student(Tablename, Id),
             if 
                 Testid == [] ->
                     ets:insert(Tablename, {Id, Name, Lastname, Skype, Currentmark = 0, Datestamp = date()});
                 true -> 
                     'The student has already exist!'
              end;
         true -> 'Wrong input!'
    end.  


update_student(Tablename, Id, Name, Lastname, Skype, Currentmark) ->
    Marktest = test_value(Currentmark),
    if
        Marktest == true ->
            Testid = find_student(Tablename, Id),
                if 
                    Testid /= [] ->
                        ets:insert(Tablename, {Id, Name, Lastname, Skype, Currentmark, Datestamp = date()});
                    true -> 
                        'The student does not exist!'
                end;
         true -> 'Wrong input!'
    end. 

find_student(Tablename, Id) ->
    ets:lookup(Tablename, Id).

find_by_date(Tablename, Y, M, D) ->
    		Comparedate = {Y, M, D},
    		MS = ets:fun2ms(fun({Id, Name, Lastname, Skype, Currentmark, Datestamp}) 
        		when Datestamp == Comparedate ->
            		[Id, Name, Lastname, Skype, Currentmark] end),
    		ets:select(Tablename, MS).

find_by_daterange(Tablename, Y1, M1, D1, Y2, M2, D2) -> 
    		Date1 = {Y1, M1, D1},
    		Date2 = {Y2, M2, D2},
    		MS = ets:fun2ms(fun({Id, Name, Lastname, Skype, Currentmark, Datestamp}) 
        		when Datestamp > Date1 andalso Datestamp < Date2 ->
            		[Id, Name, Lastname, Skype, Currentmark] end),
    		ets:select(Tablename, MS).


delete_student(Tablename, Id) ->
    ets:delete(Tablename, Id).

delete_group(Tablename) ->
    ets:delete(Tablename).

test_value(Test) ->
    if
        Test < 1 orelse is_integer(Test) == false ->
            false;
        true -> true
    end.


%%-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

myapi_test_()->[
	?_assertEqual(first, create_new_group(first)),
	?_assertEqual('Wrong input!', add_new_student(first, wewer67, 'Tim', 'Dou', 'skype60')),
	?_assertEqual('Wrong input!', add_new_student(first, -27, 'Tim', 'Dou', 'skype60')),
	?_assertEqual('Wrong input!', add_new_student(first, 22.13, 'Tim', 'Dou', 'skype60')),
	?_assertEqual(true, add_new_student(first, 1, 'Tim', 'Dou', 'skype60')),
	?_assertEqual('The student has already exist!', add_new_student(first, 1, 'Tim', 'Dou', 'skype60')),
	?_assertEqual([{1, 'Tim', 'Dou', 'skype60',0, date()}], find_student(first, 1)),
	?_assertEqual('The student does not exist!', update_student(first, 48, 'Tom', 'Johnson', 'skype64',35)),
	?_assertEqual('Wrong input!', update_student(first, 1, 'Tom', 'Johnson', 'skype64',-35)),
	?_assertEqual('Wrong input!', update_student(first, 1, 'Tom', 'Johnson', 'skype64', 35.09)),
	?_assertEqual('Wrong input!', update_student(first, 1, 'Tom', 'Johnson', 'skype64', fsdjgd5)),
	?_assertEqual(true, update_student(first, 1, 'Tom', 'Johnson', 'skype64',35)),
	?_assertEqual([{1, 'Tom', 'Johnson', 'skype64',35, date()}], find_student(first, 1)),
	?_assertEqual([[1, 'Tom', 'Johnson', 'skype64',35]], find_by_daterange(first, 2011,9,9,2017,2,2)),
	?_assertEqual([], find_by_daterange(first, asd,-99,9.33,2017,2,2)),
	?_assertEqual([], find_by_date(first, sdf,22,e3)),
	?_assertEqual(true, delete_student(first, 1)),
	?_assertEqual([], find_student(first, 1)),
	?_assertEqual(true, delete_group(first)),
	?_assertEqual(true,test_value(4)),
	?_assertEqual(false,test_value(0)),
	?_assertEqual(false,test_value(-4)),
	?_assertEqual(false,test_value(4.5)),
	?_assertEqual(false,test_value(dsfsf))].
%%-endif.

%% End of Module.
