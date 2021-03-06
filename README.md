# baseline 🏁

[![Build Status](https://app.travis-ci.com/bedekelly/baseline.svg?token=kgeEVrjr8Gq22pbFZQKn&branch=main)](https://app.travis-ci.com/bedekelly/baseline)
![Lighthouse Score: 100](https://img.shields.io/badge/Lighthouse%20Score-100-brightgreen)

A pretty good template for a React app.

## Features


**Performance & Production-Readiness**
- Makefile targets to “cache” build steps
- Fast builds with Vite
- Code splitting with React.lazy()
- 99/100 performance on Lighthouse out of the box

**Modern Libraries:**
- Routing with React-Router (v6)
- Styling with Tailwind (v3, with JIT)
- Component library setup with Storybook (built with Vite!)

**Code Quality:**
- Precommit hooks with Husky
- Linting with ESLint
- Autoformatting with Prettier
- Unit tests with Jest (including coverage)
- Integration tests with Playwright

**Developer Experience**
- Storybook to work on components in isolation
- `make component` script to create a component with tests, Storybook etc.
- Visualised build dependencies with GraphViz
- Tailwind-Override to define a styleable component library

**Third-Party Providers**
- Feature flags with Flagsmith
- ~~Crash reporting with Rollbar~~ -- removed as it's just a script tag.
- CI testing, linting and formatting with Travis


## Quickstart: Install & Run Dev Server

```bash
git clone https://github.com/bedekelly/baseline app
# Add Flagsmith environment tokens to `env/dev.env` and `env/prod.env`.
cd app; make start
```

## Creating & Serving a Production Build

```bash
make serve
```

## Tests, Linting, Formatting

```bash
$ make check        # Linting, unit tests, integration tests, formatting
$ make lintfix      # ESLint with automatic fixing
$ make format       # Prettier with automatic fixing
$ make unit         # Only run unit tests
$ make integration  # Only run integration tests
```

## Specifying Environments

```bash
$ make serve ENV=dev   # Create and serve a production build using `.env.dev` file.
$ make serve ENV=prod  # Create a production build using `.env.prod` file.
$ make start ENV=qa    # Start dev server using `.env.qa` file.
```

## More Commands

```bash
$ make component        # Create a new component with unit test and storybook files
$ make storybook        # Start a live-reloading Storybook server for your components.
$ make storybook-build  # Build your Storybook into a static site to be deployed remotely.

$ make build            # Check and create a production build, but don't serve it.
$ make serve-existing   # Serve the existing production build, ignoring dependencies.
$ make deploy           # Create production build then run deployment script.
$ make visualise        # Create and open Dependencies PDF (requires Python and GraphViz).
```

## Makefile

Using a Makefile is probably the most controversial choice here. This is done for a
few reasons, such as:

- Ease of chaining together operations (e.g. `make lintfix format test`)
- Only running dependencies when needed.
- Parallel builds

This setup looks intimidating, but I've listed some examples of how to interpret the graph below.

![Big graph showing scary dependency tree](./Dependencies.png)

### Example 1: Building & Serving the App

1. Run `make serve`
2. `serve` depends on the app having been built, aka the `build` job.
3. `build` depends on a code quality `check`, and then creates the `dist` folder.
4. `check` runs `test`ing, `lint`ing, `typecheck`ing, and `checkformat`ing on the codebase
5. `test` runs both `unit` and `integration` tests.
6. `unit` tests rely on the files marked as `Unit Tests`, the `node_modules`, and the `TypeScript Source` -- but they don't rely on the CSS source or the Env files, for example.

There's some magic here with the grayed-out file labeled `.make/unit`. This is a timestamp we create so that Make can see when we last ran unit tests, and compare that against the latest changes to the unit test files. If there are recent changes to the unit test files, we run the suite of unit tests again; if not, we can safely skip it!

### Example 2: Commit Hooks

1. Run `make check` while developing a new feature
2. Edit a CSS source file
3. Run `make serve` to run a file server.

Here, `make serve` depends on `build`, which depends on `check`. `check` will run both unit and integration tests. **However**, because `unit` doesn't depend on the CSS source files, Make knows we can safely skip it. We do re-run integration tests, since by using a library like Playwright we can check if our CSS changes have [obscured a previously-visible element](https://playwright.dev/docs/actionability).

## Interpreting the Makefile Graph

In this graph, round nodes are "phony" (i.e. they don't correspond to a real file), whereas rectangular nodes are real files like `package.json`, and Unit Tests.

I've grouped lots of these files together into a single node, which matches up with the way I've used variables in the Makefile. This makes things lots easier to read!

To interpret the graph, look at the bottom commands and what they depend on.
For example, running `make deploy` will depend on the `build` task. The `build` task in turn depends on `node_modules`, `test`, `typecheck`, `lint`, `checkformat`, and `dist`, and so on.

I've also got some greyed-out nodes which are real files, but probably not ones we care about. These are used to record the last time a command was run, e.g. when unit
tests last passed. This is useful since running tests might be a slow operation and
it's useful to skip it if the input files haven't changed.

## Parallel Builds

Parallel builds are a very new feature to me, so I'm not fully confident they're working as planned. It's quite possible that to support parallel builds, it'd make sense to avoid all mutating jobs (e.g. Prettier's `--write` and ESLint's `--fix`).

Unfortunately, all I have in front of me is a dual-core Intel machine, so...

```
$ time make -B build
...
make -B build  34.88s user 2.37s system 143% cpu 25.916 total

$ time make -Bj build
...
make -Bj build  35.86s user 2.73s system 173% cpu 22.263 total
```

## Possible Future Features

- Format and lint _fixing_ on commit (instead of just checking)
- Create new pages with a Makefile script
- Pluggable "design system" package with easy switch command between local/deployed versions
- Metrics reporting / usage
- Two-token authentication framework (e.g. Cognito, OAuth2)
- Support for a CMS/authoring system like Strapi
- Prerender/skeleton build with multiple pages to speed up first paint time
- Makefile script to create a new automatically-deployed environment
