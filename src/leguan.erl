-module(leguan).

-export([main/1]).

-include("leguan.hrl").


-record(data, {nodes,
	       modules,
	       cookie,
	       code_paths}).

main(Args) ->
    case get_data(Args) of
	{ok, Data} ->
	    set_cookie(Data),
	    connect_nodes(Data),
	    add_code_paths(Data),
	    check_modules(Data),
	    
	    load_modules(Data);
	Else -> 
	    ?ERROR("~p", [Else]),
	    halt(1)
    end.

   
get_data(_Args)->
    Filename = "leguan.config",
    case file:consult(Filename) of
	{ok, Terms} ->
	    parse_terms(Terms);
	{error, Error} -> {error, {"leguan.config", Error}}
    end.
	    

parse_terms(Terms) ->
    Nodes =  
    	case proplists:get_value(nodes, Terms) of
    	    undefined ->
    		?ERROR("no nodes", []),
		halt(1);
    	    Ns -> Ns
    	end,
    Modules =  
    	case proplists:get_value(modules, Terms) of
    	    Mods when Mods == undefined; Mods == [] ->
    		?ERROR("no modules", []),
		halt(1);
    	    Ms -> Ms
    	end,

    Cookie = proplists:get_value(cookie, Terms, riak),
    CodePaths = proplists:get_value(ebin, Terms, []),
    Data = #data{nodes=Nodes,
		 modules=Modules,
		 cookie=Cookie,
		 code_paths=CodePaths
		},
    {ok, Data}.


set_cookie(Data)->
    erlang:set_cookie(node(),  Data#data.cookie).

connect_nodes(Data)->
    lists:foreach(
      fun(Node) ->
	      case net_adm:ping(Node) of
		  pong ->
		      ok;
		  pang ->
		      ?WARNING("not connected to ~p", [Node])
	      end
      end,
      Data#data.nodes). 


    
add_code_paths(Data) ->
    code:add_pathsa(Data#data.code_paths).

check_modules(Data)->
    lists:foreach(
      fun(Mod) ->
	      case code:ensure_loaded(Mod) of
		  {module, _M} -> ok;
		  false ->
		      ?ERROR("module ~p not found!!", [Mod]),
		      halt(1)
	      end
      end,
      Data#data.modules).




load_modules(Data)->
    Nodes = Data#data.nodes,    
    lists:foreach(
      fun(Mod) ->
	      {Module, Binary, Filename} = code:get_object_code(Mod), 
	      lists:foreach(fun(Node) -> load_mod(Node, Module, Binary, Filename) end,
			    Nodes)
      end,
      Data#data.modules).

	  
load_mod(Node, Module, Binary, Filename) ->
    rpc:call(Node, code, purge, [Module]),
    Reply = rpc:call(Node, code, load_binary, [Module, Filename, Binary]),
    case Reply of
	{module,Module} ->
	    ?INFO("~p module: ~p -> ok", [Node, Module]);
	Reply ->
	    ?ERROR("~p module: ~p -> ~p", [Node, Module, Reply])
    end.
    
