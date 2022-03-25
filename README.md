# bede/app
My template for the perfect React app -- or at least, a pretty good one.

Some features it has so far:

* Build/Deploy/Test scripts in a Makefile, not package.json, for easier chaining (e.g. `make lint typecheck test`)
* Automatic deployment to environments via git tags

# Future Features
* Build tool should be v fast (e.g. Vite)
* Hot reloading
* Unit tests
* Integration tests
* Linting
* Autoformatting
* Separate NPM package with a design system
* Develop with that package locally with hot reloading
* Scripts for running with local vs remote copy of design system package
* Master + feature branches
* Feature flags using LaunchDarkly
* Create new API layer microservices with a single command
* Create new pages with a single command
* Code splitting
* Crash reporting
* Metrics reporting / usage
* Two-token authentication framework (e.g. Cognito, OAuth2)
* CMS/Authoring
