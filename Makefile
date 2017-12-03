REBAR = $(shell pwd)/rebar3
APP=sb_core

.PHONY: all ct test clean elvis compile

all: compile

clean:
	$(REBAR) cover -r
	$(REBAR) clean

eunit:
	$(REBAR) eunit
	$(REBAR) cover -v

ct:
	$(REBAR) ct
	$(REBAR) cover -v

tests: elvis eunit ct
	$(REBAR) dialyzer

rel:
	$(REBAR) release

run: rel
	./_build/default/rel/cargotube/bin/cargotube


elvis:
	$(REBAR) lint

compile:
	$(REBAR) compile
