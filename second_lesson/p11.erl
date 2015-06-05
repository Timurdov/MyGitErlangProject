-module(p11).
-export([encode_modified/1]).

encode_modified(L) -> p05:reverse(encode_modified(L, 0, [])).

encode_modified([], Counter, Acc) -> Acc;

encode_modified([H|[]], 0, Acc) -> encode_modified([], 0, [H|Acc]);

encode_modified([A,A|T], Counter, Acc) -> encode_modified([A|T], Counter+1, Acc);

encode_modified([A,B|T], 0, Acc) -> encode_modified([B|T], 0, [A|Acc]);

encode_modified([H|T], Counter, Acc) -> G = {Counter+1, H}, encode_modified(T, 0, [G|Acc]).







