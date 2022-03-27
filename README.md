# baseline 🏁

A pretty good template for a React app.

Some features it has so far:

- Build/Deploy/Test scripts in a Makefile
- Fast builds with Vite
- Hot module reloading
- Unit tests with Jest
- Feature flags with Flagsmith
- Linting with ESLint
- Autoformatting with Prettier
- Routing with React-Router (v6)
- Styling with Tailwind (v3, with JIT)
- Precommit hooks with Husky
- Integration tests with Playwright
- Visualised dependencies with GraphViz

## Makefile

Using a Makefile is probably the most controversial choice here. This is done for a
few reasons, such as:

- Ease of chaining together operations (e.g. `make lint format test`)
- Only running dependencies when needed.
- Parallel builds

This second one isn't supported by package.json scripts at all, so it's not seen in
many modern JS projects, but it's incredibly useful.

Consider the situation where you've got a precommit hook set up. You want the strongest
guarantees about the code you're checking in, so you're running typechecking, unit testing,
integration testing, linting, and more when you commit code. This gets quite annoying when
you've just _fixed_ a bug with unit tests, and so you've been running your test suite anyway.

Another case to consider is fixing a style bug in a CSS file. We'd like to make sure
nothing is obstructed from view using our integration tests, but there's no point running
a bunch of unit tests on unrelated components.

These and more are supported by Make, which uses file modification timestamps to compare
its "targets" (output files) and "dependencies" (input files) to determined whether it
needs to run the script again.

Many combinations of scripts are useful in different cases, and despite looking a bit intimidating, this configuration seems like a good setup so far:

![Big graph showing scary dependency tree](./Dependencies.png)

In this graph, round nodes are "phony" (i.e. they don't correspond to a real file), whereas rectangular nodes are real files like `package.json`, and Unit Tests.

I've grouped lots of these files together into a single node, which matches up with the way I've used variables in the Makefile. This makes things lots easier to read!

To interpret the graph, look at the bottom commands and what they depend on.
For example, running `make deploy` will depend on the `build` task. The `build` task in turn depends on `node_modules`, `test`, `typecheck`, `lint`, `format`, and `dist`, and so on.

I've also got some greyed-out nodes which are real files, but probably not ones we care about. These are just used to record the last time a command was run, e.g. when unit
tests last passed. This is useful since running tests might be a slow operation and
it's useful to skip it if the input files haven't changed.

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

## Future Features

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
- Multi-environment config (i.e. easy solution to create a new environment with a config)
