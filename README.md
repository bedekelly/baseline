# baseline 🏁

A pretty good template for a React app.

Some features it has so far:

- Build/Deploy/Test scripts in a Makefile\*
- Automatic deployment to environments via git tags
- Fast builds with Vite
- Hot module reloading
- Unit tests with Jest
- Feature flags with Flagsmith
- Linting with ESLint
- Autoformatting with Prettier
- Routing with React-Router (v6)
- Styling with Tailwind (v3, with JIT)
- Precommit hooks with Husky

\*i.e., not a package.json script, for easier chaining (e.g. `make lint typecheck test`) and dependency management (e.g. skip linting when there's no change to source files).

# Future Features

- Integration tests
- Separate NPM package with a design system
- Develop with that package locally with hot reloading
- Scripts for running with local vs remote copy of design system package
- Automatic feature/demo branch deployment
- Create new API layer microservices with a single command
- Create new pages with a single command
- Code splitting
- Crash reporting
- Metrics reporting / usage
- Two-token authentication framework (e.g. Cognito, OAuth2)
- CMS/Authoring
- Prerender/skeleton build
