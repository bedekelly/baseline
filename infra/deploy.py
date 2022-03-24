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


def get_past_environments():
    with open("../parsed_revisions.json") as revs_file:
        parsed_revisions = json.loads(revs_file.read())
        return parsed_revisions


def get_environments():
    with open("infra/environments.json") as environments_file:
        environments_obj = json.loads(environments_file.read())
        environments = environments_obj["environments"]
        for key in environments.keys():
            commit = repo.rev_parse(environments[key]["checkout"])
            environments[key]["commit"] = commit.hexsha
        return environments


def deploy_environments(environments):
    for environment, environment_options in environments.items():
        target = environment_options["checkout"]
        print(f"Deploying '{environment}' using git target <{target}>")
        repo.git.checkout(target)
    repo.git.checkout("main")


def get_env_diff():
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
    with open("../parsed_revisions.json", "w") as revs_file:
        json.dump(new_environments, revs_file, indent=2)


added, deleted, modified = get_env_diff()
print(f"Added: {added}\nDeleted: {deleted}\nModified: {modified}")

envs = get_environments()
save_environments(envs)
