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


repo = Repo(os.getcwd(), search_parent_directories=False)


def get_past_environments():
    return None


def get_environments():
    with open("infra/environments.json") as environments_file:
        environments_obj = json.loads(environments_file.read())
        environments = environments_obj["environments"]
        for key in environments.keys():
            environments[key]['commit'] = repo.rev_parse(environments[key]['checkout']).hexsha
        repo.git.checkout("-")
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
        current_rev = current_environments[modified_env_name]["checkout"]
        past_rev = past_environments[modified_env_name]["checkout"]

        current_commit = repo.rev_parse(current_rev)
        past_commit = repo.rev_parse(past_rev)

        if current_commit.hexsha != past_commit.hexsha:
            modified_envs.append(modified_env_name)

    return added_envs, deleted_envs, modified_envs


# added, deleted, modified = get_env_diff()
# print(f"Added: {added}\nDeleted: {deleted}\nModified: {modified}")

print(get_environments())
