-module(p12).
-export([decode_modified/1]).

decode_modified(L) -> p05:reverse(decode_modified(L, [])).

decode_modified([], Acc) -> Acc;

decode_modified([{}|T], Acc) ->  decode_modified(T, Acc);

decode_modified([{A}|T], Acc) ->  decode_modified(T, Acc);

decode_modified([{1,A}|T], Acc) ->  decode_modified(T, Acc);

decode_modified([[_|_]|T], Acc) ->  decode_modified(T, Acc);

decode_modified([{A,B}|T], Acc) -> 
	G = p15:replicate([B],A), 
	decode_modified(T,  G ++ Acc);

decode_modified([H|T], Acc) ->  decode_modified(T, [H | Acc]).







