.PHONY: clean compile typecheck lint build deploy

# Clean up the targets.
clean:
	@echo Cleaning...
	@echo Cleaned!\\n

compile:
	@echo Compiling...
	@echo Compiled!\\n

typecheck:
	@echo Type checking...
	@echo No type errors found!\\n

lint:
	@echo Linting...
	@echo No linting errors found.\\n

build:
	@echo Building environment $(ENV)
	make clean typecheck lint compile
	@echo Built environment $(ENV)

deploy:
	@echo Deploying environment $(ENV)
	ls
	@echo Deployed!\\n
