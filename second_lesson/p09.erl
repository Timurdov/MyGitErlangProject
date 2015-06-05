-module(p09).
-export([pack/1]).

pack(L) -> p05:reverse(pack(L, [], [])).

pack([], Acc, Acc1) -> Acc1;

pack([A,A|T], Acc, Acc1) -> pack([A|T], [A|Acc], Acc1);

pack([H|T], Acc, Acc1) -> G = [H|Acc], pack(T, [], [G|Acc1]).







