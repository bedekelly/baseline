# The big benefit of using a Makefile is to avoid pointless re-running of
# tests, linting, type checking etc., as can often happen with package.json
# scripts.

# Make does this by default with non-phony targets, since it compares
# everything just by using files' last-modified timestamps.


TS 			:= $(shell find src -iname "*.ts")
TEST_FILES	:= $(shell find src -iname "*.test.*")
CSS 		:= $(shell find src -iname "*.css")
ENV_FILES	:= $(shell find env  -iname "*.env")
SOURCE 		:= $(TS) $(CSS) $(ENV_FILES)

BIN			:= node_modules/.bin
SHELL		:= /bin/bash
ENV			:= dev

.PHONY: help
help:
	@echo "usage: make [target] ..."
	@echo "targets:"
	@echo "* deploy"
	@echo "* build"
	@echo "* serve"
	@echo "* check (typecheck, lint, dist)"
	@exit 1

node_modules: package.json
	yarn
	@touch $@

.PHONY: build
build: check dist

.PHONY: format
format: .make/format
.make/format: $(SOURCE) node_modules
	$(BIN)/prettier --loglevel=warn --write .
	@touch $@

.PHONY: check
check: format typecheck lint test

.PHONY: test
test: unit integration

.PHONY: unit
unit: .make/unit
.make/unit: $(TS) $(TEST_FILES) node_modules
	$(BIN)/jest
	@touch $@

.PHONY: integration
integration: .make/integration
.make/integration: $(SOURCE) $(wildcard integration/*.ts) playwright.config.ts node_modules
	$(BIN)/playwright test
	@touch $@

.PHONY: always-rebuild
.make/environment: always-rebuild
	@echo $(ENV) > .make/environment.new
	@cmp --quiet .make/environment.new .make/environment || cp .make/environment{.new,}
	@rm .make/environment.new

dist: $(SOURCE) .make/environment node_modules
	$(BIN)/env-cmd -f env/$(ENV).env $(BIN)/vite build
	@touch $@

.PHONY: typecheck
typecheck: .make/typecheck
.make/typecheck: $(TS) node_modules
	$(BIN)/tsc --noEmit
	@echo
	@touch $@

.PHONY: lint
lint: .make/lint
.make/lint: $(TS) node_modules
	$(BIN)/eslint --cache --fix .
	@touch $@

.PHONY: delete
delete:
	@echo Deleting environment $(ENV)...
	@echo Deleted.
	@echo

.PHONY: serve
serve: build
	npx serve dist -c ../serve.json

.PHONY: serve-existing
serve-existing: dist
	npx serve dist -c ../serve.json

.PHONY: deploy
deploy: build
	@echo Deploying environment $(ENV)
	@echo Deployed!
	@echo

.PHONY: start
start: node_modules
	$(BIN)/env-cmd -f env/$(ENV).env $(BIN)/vite

.PHONY: visualise
visualise: visualise.pdf
visualise.pdf:
	python3 generate_makefile_graph.py
