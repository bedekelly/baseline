SOURCE_CODE=$(wildcard *.ts *.js *.tsx *.jsx)

node_modules: package.json
	yarn
	touch $@

.PHONY: build
build: node_modules typecheck lint compile
	@test $(ENV) || (echo "ENV was not set" && exit 1)
	@echo Building environment $(ENV)...
	@echo Built environment $(ENV).
	@echo

.PHONY: compile
compile: dist
dist: $(SOURCE_CODE)
	@echo Compiling...
	@echo Compiled!
	@echo
	@touch $@

.PHONY: typecheck
typecheck: .make/last_typechecked
.make/last_typechecked: $(SOURCE_CODE)
	@echo Type checking...
	@echo No type errors found!
	for file in $^; do echo $$file; done
	@echo
	@touch $@

.PHONY: lint
lint: .make/last_linted
.make/last_linted: $(SOURCE_CODE)
	@echo Linting...
	@sleep 5
	@echo No linting errors found.
	@touch $@

.PHONY: delete
delete:
	@echo Deleting environment $(ENV)...
	@echo Deleted.
	@echo

.PHONY: deploy
deploy:
	@test $(ENV) || (echo "ENV was not set" && exit 1)
	@echo Deploying environment $(ENV)
	@echo Deployed!
	@echo
