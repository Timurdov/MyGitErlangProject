-module(p02).
-export([butlast/1]).

butlast([_,_|[]] = L) -> L;
butlast([H|T]) -> butlast(T).


