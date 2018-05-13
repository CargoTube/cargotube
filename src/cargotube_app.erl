%%%-------------------------------------------------------------------
%% @doc cargotube public API
%% @end
%%%-------------------------------------------------------------------

-module(cargotube_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    add_realms(),
    update_version_settings(),
    cargotube_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================


add_realms() ->
    RealmConfig = application:get_env(cargotube, realms, []),
    AddRealm = fun({Name, Auth, Mapping} , _) ->
                       cta_realm:new(Name, Auth, Mapping)
               end,
    lists:foldl(AddRealm, ok, RealmConfig).


update_version_settings() ->
    {ok, Vsn} = application:get_key(vsn),
    Version = application:get_env(cargotube, version, Vsn),
    application:set_env(cargotube, version, Version).
