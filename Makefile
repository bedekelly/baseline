# App Makefile
# The big benefit of using a Makefile is to avoid pointless re-running of
# tests, linting, type checking etc., as can often happen with package.json
# scripts.

# Make does this by default with non-phony targets, since it compares
# everything just by using files' last-modified timestamps.


SOURCE_CODE := $(shell find src -iname "*.tsx")
BIN			:= node_modules/.bin
SHELL		:= /bin/bash
ENV			:= dev

.PHONY: help
help:
	@echo "usage: make [target] ..."
	@echo "targets:"
	@echo "* deploy"
	@echo "* build"
	@echo "* check (typecheck, lint, dist)"
	@exit 1

node_modules: package.json
	yarn
	@touch $@

.PHONY: build
build: node_modules format lint test dist

.PHONY: format
format: .make/last_formatted
.make/last_formatted: $(SOURCE_CODE)
	$(BIN)/prettier --loglevel=warn --write .
	@touch $@

.PHONY: check
check: node_modules typecheck lint test

.PHONY: test
test: unit integration

.PHONY: unit
unit: .make/last_unit_tested
.make/last_unit_tested: $(SOURCE_CODE)
	$(BIN)/jest
	@touch $@

.PHONY: integration
integration: .make/last_integration_tested
.make/last_integration_tested: $(SOURCE_CODE)
	@echo No integration tests configured.
	@touch $@

dist: .make/last_typechecked
	$(BIN)/env-cmd -f .env.$(ENV) $(BIN)/vite build

.PHONY: typecheck
typecheck: .make/last_typechecked $(SOURCE_CODE)
.make/last_typechecked: $(SOURCE_CODE)
	$(BIN)/tsc --noEmit
	@echo
	@touch $@

.PHONY: lint
lint: .make/last_linted .make/last_formatted $(SOURCE_CODE)
.make/last_linted: $(SOURCE_CODE)
	$(BIN)/eslint --fix .
	@touch $@

.PHONY: delete
delete:
	@echo Deleting environment $(ENV)...
	@echo Deleted.
	@echo

.PHONY: serve
serve:
	npx serve dist

.PHONY: deploy
deploy: build
	@echo Deploying environment $(ENV)
	@echo Deployed!
	@echo


NPM_BIN = $(shell npm bin)

.PHONY: start
start: node_modules
	$(BIN)/env-cmd -f .env.$(ENV) $(BIN)/vite
