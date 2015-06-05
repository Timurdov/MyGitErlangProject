-module(p06).
-export([is_polindrome/1]).

is_polindrome(L) -> is_polindrome(L,L,[]).

is_polindrome(K,[H|T], Acc) -> is_polindrome(K,T, [H]++Acc);

is_polindrome([],[], Acc) -> false;

is_polindrome([H|[]],[], Acc) -> false;

is_polindrome(K,[], Acc) -> K=:=Acc.
