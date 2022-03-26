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
	@echo "* serve"
	@echo "* check (typecheck, lint, dist)"
	@exit 1

node_modules: package.json
	yarn
	@touch $@

.PHONY: build
build: node_modules format lint test dist

.PHONY: format
format: .make/format
.make/format: $(SOURCE_CODE)
	$(BIN)/prettier --loglevel=warn --write .
	@touch $@

.PHONY: check
check: node_modules .make/typecheck .make/lint test

.PHONY: test
test: .make/unit .make/integration

.PHONY: unit
unit: .make/unit
.make/unit: $(SOURCE_CODE)
	$(BIN)/jest
	@touch $@

.PHONY: integration
integration: .make/integration
.make/integration: $(SOURCE_CODE)
	@echo No integration tests configured.
	@touch $@

dist: .make/typecheck
	$(BIN)/env-cmd -f .env.$(ENV) $(BIN)/vite build

.PHONY: typecheck
typecheck: .make/typecheck $(SOURCE_CODE)
.make/typecheck: $(SOURCE_CODE)
	$(BIN)/tsc --noEmit
	@echo
	@touch $@

.PHONY: lint
lint: .make/lint .make/format $(SOURCE_CODE)
.make/lint: $(SOURCE_CODE)
	$(BIN)/eslint --cache --fix .
	@touch $@

.PHONY: delete
delete:
	@echo Deleting environment $(ENV)...
	@echo Deleted.
	@echo

.PHONY: serve
serve: build
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
