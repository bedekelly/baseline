"""
Adapted from ChadsGilbert:
https://github.com/chadsgilbert/makefile2dot/blob/master/makefile2dot/__init__.py

Requirements:
    - Python 3
    - graphviz (System software: brew/apt-get install graphviz)
    - graphviz (Python library:  python3 -m pip install graphviz)
"""

import subprocess as sp
import graphviz as gv
from collections import defaultdict


dependency_patterns = [
    ["integration/", "Integration Tests"],
    [".test.", "Unit Tests"],
    [".css", "CSS Source"],
    [".ts", "TypeScript Source"],
    [".env", "Env files"],
    # This is slightly changing the semantics of what's going on, since really
    # the dependency actually *is* the `.make/environment` file. But this makes
    # the graph make a lot more sense.
    ["always-rebuild", "Environment Variables"],
]


def stream_database():
    """
    Generate and yield entries from the Makefile database.
    This function reads a Makefile using the make program (only tested with GNU
    Make) on your machine. It in turn generates the database constructed from
    the Makefile, ignoring default targets ("-r").
    """
    command = ["make", "-prnB"]
    with sp.Popen(command, stdout=sp.PIPE, universal_newlines=True) as proc:
        for line in proc.stdout:
            if line[0] == "#":
                continue
            if line.isspace():
                continue
            if (
                "DEFAULT" in line
                or "SUFFIXES" in line
                or "Makefile" in line
                or "always-rebuild:" in line
            ):
                continue
            if ": " not in line and not line.strip("\n").endswith(":"):
                continue
            if line.startswith("\t") or line.startswith("echo"):
                continue
            if line[0] == "&":
                continue
            yield line.strip()


def build_graph(stream, **kwargs):
    """
    Build a dependency graph from the Makefile database.
    """
    graph = gv.Digraph(comment="Makefile")
    graph.attr(rankdir=kwargs.get("direction", "TB"))

    phony_targets = set()

    # Draw all our collected dependencies (e.g. "CSS Source Files") as rectangles.
    for _, name in dependency_patterns:
        graph.node(name, shape="rectangle")

    for line in stream:
        print(line)
        target, dependencies = line.split(":")
        dependencies = [d for d in dependencies.strip().split(" ") if d]

        # Keep a set of all the phony (i.e. non-real-file) targets in the Makefile.
        # N.B. This only works because this is right at the top of the DB output.
        if target == ".PHONY":
            phony_targets = set(dependencies)
            continue

        existing_dependencies = defaultdict(lambda: False)

        # Draw a node only if this target doesn't match an existing pattern (e.g. .CSS).
        if not any(pattern in target for pattern, _ in dependency_patterns):
            graph.node(
                target,
                shape=("circle" if target in phony_targets else "rectangle"),
                fontcolor=("#777777" if ".make" in target else "#000000"),
                color=("#999999" if ".make" in target else "#000000"),
            )

        # Draw single edges to represent dependencies, e.g. from "format" to
        # "TypeScript Source".
        for dependency in dependencies:
            should_draw = True
            for pattern, name in dependency_patterns:
                if pattern in dependency:
                    dependency = name
                    if existing_dependencies[name]:
                        should_draw = False
                        break
                    existing_dependencies[dependency] = True
            if should_draw:
                graph.edge(target, dependency)

    return graph


def makefile2dot(**kwargs):
    """
    Visualize a Makefile as a Graphviz graph.
    """

    direction = kwargs.get("direction", "BT")
    if direction not in ["LR", "RL", "BT", "TB"]:
        raise ValueError('direction must be one of "BT", "TB", "LR", RL"')

    graph = build_graph(stream_database(), direction=direction)
    graph.directory = "/tmp/baseline"
    graph.filename = "Dependencies"
    graph.view()


if __name__ == "__main__":
    makefile2dot(direction="BT")
