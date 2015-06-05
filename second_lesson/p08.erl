-module(p08).
-export([compress/1]).

compress(L) -> p05:reverse(compress(L, [])).

compress([], Acc) -> Acc;

compress([H | []], Acc) -> [H | Acc];

compress([A,A | T], Acc) -> G=[A|T], compress(G, Acc);

compress([H | T], Acc) -> compress(T, [H | Acc]).







