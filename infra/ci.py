"""
deploy.py

Figure out the changes since the last commit on this branch that changed the
environment file.

Run from the root directory, as:
    $ python3 infra/deploy.py
"""
import os
import json
from git import Repo
from pprint import pprint


repo = Repo(os.getcwd(), search_parent_directories=False)
repo.git.stash()


def get_past_environments():
    with open("../parsed_revisions.json") as revs_file:
        parsed_revisions = json.loads(revs_file.read())
        return parsed_revisions


def get_environments():
    with open("infra/environments.json") as environments_file:
        environments = json.loads(environments_file.read())
        for key in environments.keys():
            commit = repo.rev_parse(environments[key]["checkout"])
            environments[key]["commit"] = commit.hexsha
        return environments


def deploy_environment(name, options):
    target = options["checkout"]
    print("\n")
    print(f"ℹ Deploying '{name}' using git target <{target}>")
    repo.git.checkout(target)
    print("\n$ git status")
    print(repo.git.status())
    print(f"$ make build {name}")
    print(os.listdir())
    print("\n")
    repo.git.checkout("main")


def get_env_diff():
    """Get the added, removed, and modified environmnents."""
    past_environments = get_past_environments()
    current_environments = get_environments()

    past_env_names = set(past_environments.keys())
    current_env_names = set(current_environments.keys())

    deleted_envs = list(past_env_names - current_env_names)
    added_envs = list(current_env_names - past_env_names)
    maybe_modified = current_env_names & past_env_names
    modified_envs = []

    for modified_env_name in maybe_modified:
        current_rev = current_environments[modified_env_name]["commit"]
        current_commit = repo.rev_parse(current_rev)
        past_commit_hash = past_environments[modified_env_name]["commit"]

        if current_commit.hexsha != past_commit_hash:
            modified_envs.append(modified_env_name)

    return added_envs, deleted_envs, modified_envs


def save_environments(new_environments):
    """Cache the commit hash for every revision in our current environments."""
    with open("../parsed_revisions.json", "w") as revs_file:
        json.dump(new_environments, revs_file, indent=2)


def delete_environment(env_name):
    print(f"Deleting deployment of environment: {env_name}")


added, deleted, modified = get_env_diff()

past_environments = get_past_environments()
environments = get_environments()
new_environments = {**past_environments}


for added_environment in added:
    print(f"Deploying new environment: {added_environment}")
    try:
        deploy_environment(added_environment, environments[added_environment])
    except Exception as e:
        print(e)
    else:
        new_environments[added_environment] = environments[added_environment]


for deleted_environment in deleted:
    print(f"Removing environment: {deleted_environment}")
    try:
        delete_environment(deleted_environment)
    except Exception as e:
        print(e)
    else:
        del new_environments[deleted_environment]


for modified_environment in modified:
    print(f"Updating environment: {modified_environment}")
    try:
        deploy_environment(modified_environment, environments[modified_environment])
    except Exception as e:
        print(e)
    else:
        new_environments[modified_environment] = environments[modified_environment]

if len(added) + len(deleted) + len(modified) == 0:
    print("No changes made.")

save_environments(new_environments)

repo.git.stash("pop")
