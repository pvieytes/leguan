

-define(INFO(Str, Args), io:format("INFO: " ++ Str ++ "~n", Args)).
-define(DEBUG(Str, Args), io:format("DEBUG: " ++ Str ++ "~n", Args)).
-define(WARNING(Str, Args), io:format("WARNING: " ++ Str ++ "~n", Args)).
-define(ERROR(Str, Args), io:format("ERROR: " ++ Str ++ "~n", Args)).
