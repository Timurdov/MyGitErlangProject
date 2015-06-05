-module(p10).
-export([encode/1]).

encode(L) -> p05:reverse(encode(L, 0, [])).

encode([], Counter, Acc) -> Acc;

encode([A,A|T], Counter, Acc) -> encode([A|T], Counter+1, Acc);

encode([H|T], Counter, Acc) -> G = {Counter+1, H}, encode(T, 0, [G|Acc]).







