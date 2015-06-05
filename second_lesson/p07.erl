-module(p07).
-export([flatten/1]).

flatten(L) -> flatten(L, []).

flatten([], Acc) -> Acc;

flatten([H | T], Acc) -> flatten(H, flatten(T,Acc));

flatten(H, Acc) -> [H | Acc].






