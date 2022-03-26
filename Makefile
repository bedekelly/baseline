# App Makefile
# The big benefit of using a Makefile is to avoid pointless re-running of
# tests, linting, type checking etc., as can often happen with package.json
# scripts.

# Make does this by default with non-phony targets, since it compares
# everything just by using files' last-modified timestamps.

SOURCE_CODE := $(shell find src -iname "*.tsx")

.PHONY: help
help:
	@echo "usage: make [target] ..."
	@echo "targets:"
	@echo "* deploy"
	@echo "* build"
	@echo "* check (typecheck, lint, compile)"
	@exit 1

node_modules: package.json
	yarn
	@touch $@

.PHONY: build
build: node_modules format lint test compile

.PHONY: format
format: .make/last_formatted
.make/last_formatted: $(SOURCE_CODE)
	node_modules/.bin/prettier --loglevel=warn --write .
	@touch $@

.PHONY: check
check: node_modules typecheck lint test

.PHONY: test
test: unit integration

.PHONY: unit
unit: .make/last_unit_tested
.make/last_unit_tested: $(SOURCE_CODE)
	node_modules/.bin/jest
	@touch $@

.PHONY: integration
integration: .make/last_integration_tested
.make/last_integration_tested: $(SOURCE_CODE)
	@echo No integration tests configured.
	@touch $@

.PHONY: compile
compile: dist
dist: typecheck
	node_modules/.bin/vite build
	@touch $@

.PHONY: typecheck
typecheck: .make/last_typechecked
.make/last_typechecked: $(SOURCE_CODE)
	node_modules/.bin/tsc --noEmit
	@echo
	@touch $@

.PHONY: lint
lint: .make/last_linted format
.make/last_linted: $(SOURCE_CODE)
	node_modules/.bin/eslint --fix .
	@touch $@

.PHONY: delete
delete:
	@echo Deleting environment $(ENV)...
	@echo Deleted.
	@echo

.PHONY: deploy
deploy: build
	@test $(ENV) || (echo "ENV was not set" && exit 1)
	@echo Deploying environment $(ENV)
	@echo Deployed!
	@echo


NPM_BIN = $(shell npm bin)

.PHONY: start
start: node_modules
	node_modules/.bin/vite
