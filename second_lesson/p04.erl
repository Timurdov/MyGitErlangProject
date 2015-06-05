-module(p04).
-export([len/1]).

len(L) -> len(L,0).
len([H|T], Acc) -> len(T, Acc+1);
len([], Acc) -> Acc.


