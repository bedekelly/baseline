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
	touch $@

.PHONY: build
build: node_modules lint test compile

.PHONY: check
check: node_modules typecheck lint test

.PHONY: test
test: unit integration

.PHONY: unit
unit: .make/last_unit_tested
.make/last_unit_tested: $(SOURCE_CODE)
	@echo Running unit tests...
	@sleep 3
	@echo All unit tests passed!
	@touch $@

.PHONY: integration
integration: .make/last_integration_tested
.make/last_integration_tested: $(SOURCE_CODE)
	@echo Running integration tests...
	@sleep 3
	@echo All integration tests passed!
	@touch $@

.PHONY: compile
compile: dist
dist: typecompile
	node_modules/.bin/vite build
	@touch $@

.PHONY: typecompile
typecompile: .make/last_typecompiled
.make/last_typecompiled: $(SOURCE_CODE)
	node_modules/.bin/tsc

.PHONY: typecheck
typecheck: .make/last_typechecked
.make/last_typechecked: $(SOURCE_CODE)
	@echo Type checking files: $^...
	node_modules/.bin/tsc --noEmit
	@echo No type errors found!
	@echo
	@touch $@

.PHONY: lint
lint: .make/last_linted
.make/last_linted: $(SOURCE_CODE)
	@echo Linting...
	@sleep 3
	@echo No linting errors found.
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
