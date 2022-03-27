# App Makefile
# The big benefit of using a Makefile is to avoid pointless re-running of
# tests, linting, type checking etc., as can often happen with package.json
# scripts.

# Make does this by default with non-phony targets, since it compares
# everything just by using files' last-modified timestamps.


TSX 		:= $(shell find src -iname "*.tsx")
TEST_FILES	:= $(shell find src -iname "*.test.*")
CSS 		:= $(shell find src -iname "*.css")
SOURCE 		:= $(JS) $(CSS)

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
build: node_modules format lint test typecheck dist

.PHONY: format
format: .make/format
.make/format: $(SOURCE)
	$(BIN)/prettier --loglevel=warn --write .
	@touch $@

.PHONY: check
check: node_modules typecheck lint test

.PHONY: test
test: unit integration

.PHONY: unit
unit: .make/unit
.make/unit: $(TSX)
	$(BIN)/jest
	@touch $@

.PHONY: integration
integration: .make/integration
.make/integration: $(SOURCE) $(wildcard integration/*.ts) playwright.config.ts
	$(BIN)/playwright test
	@touch $@

dist: $(SOURCE)
	$(BIN)/env-cmd -f .env.$(ENV) $(BIN)/vite build
	@touch $@

.PHONY: typecheck
typecheck: .make/typecheck
.make/typecheck: $(TSX)
	$(BIN)/tsc --noEmit
	@echo
	@touch $@

.PHONY: lint
lint: .make/lint
.make/lint: $(TSX)
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

# Useful for testing.
.PHONY: serve-existing
serve-existing:
	npx serve dist -c ../serve.json

.PHONY: deploy
deploy: build
	@echo Deploying environment $(ENV)
	@echo Deployed!
	@echo


NPM_BIN = $(shell npm bin)

.PHONY: start
start: node_modules
	$(BIN)/env-cmd -f .env.$(ENV) $(BIN)/vite

.PHONY: visualise
visualise: visualise.pdf
visualise.pdf:
	python3 generate_makefile_graph.py