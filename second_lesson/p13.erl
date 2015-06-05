-module(p13).
-export([decode/1]).

decode(L) -> p05:reverse(decode(L, [])).

decode([], Acc) -> Acc;

decode([{}|T], Acc) ->  decode(T, Acc);

decode([{A}|T], Acc) ->  decode(T, Acc);

decode([H|T], Acc) -> 
	{A,B}=H, 
	G = p15:replicate([B],A), 
	decode(T,  G ++ Acc).







