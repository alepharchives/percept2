
-module(server). 
-compile(export_all).
start() ->
    erlang:set_cookie(node(),secret),
    application:start(runtime_tools),
    Pid = spawn(?MODULE,loop,[[]]),
    register(server,Pid).
stop() -> server ! stop.
loop(Data) ->
    receive
        {put,From,Ting} -> From ! whatis(Ting),
                           loop(Data ++ [Ting]);
        {get,From}      -> From ! {ok,Data},
                           loop(Data);
        stop            -> stopped;
        clear           -> loop([])
    end.
whatis(List) when hd(List) =< 96 -> nok;
whatis(List) when hd(List) == 99 -> nok; 
whatis(List) when hd(List) == 100 -> ok;
whatis(List) when hd(List) == 101 -> ok;
whatis(List) when hd(List) >= 123 -> nok;
whatis(List) when is_integer(hd(List)) -> ok.
