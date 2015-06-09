-module(bs03).
-export([split/2]).

split(Bin, Spl) ->
    K = list_to_binary(Spl),
    Mysize = bit_size(K),
    Count = Mysize div 8,
    lists:reverse(split(Bin, Spl, K, Mysize, Count, Count, <<>>, [])).
split(<<X, Rest/binary>>, Spl, K, Mysize, Count, Count, Accbin, Acc)
    when (bit_size(<<Rest/binary>>) == Count*8) ->
        split(<<>>, Spl, K, Mysize, Count, Count, <<Accbin/binary, X, Rest/binary>>, Acc);
split(<<X, Rest/binary>>, Spl, K, Mysize, Count, Count, Accbin, Acc) ->
    B = <<X, Rest/binary>>,  
    <<Y:Mysize, Rest2/binary>> = B,    
    S = <<Y:Mysize>>,
    if 
        S == K ->
            split(Rest, Spl, K, Mysize, Count, 1, <<>>, [Accbin | Acc]);
        true -> 
            split(Rest, Spl, K, Mysize, Count, Count, <<Accbin/binary, X>>, Acc)        
    end;
split(<<X, Rest/binary>>, Spl, K, Mysize, Count, N, Accbin, Acc) ->
   split(Rest, Spl, K, Mysize, Count, N+1, <<>>, Acc);
split(<<>>, Spl, K, Mysize, Count, Count, Accbin, Acc) ->
    [Accbin|Acc].
