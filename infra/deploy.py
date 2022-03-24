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

repo.git.checkout("main")


def get_past_environments():
    repo.git.checkout("HEAD^1")
    past_environments = get_environments();
    repo.git.checkout("-")
    return past_environments


def get_environments():
    with open("infra/environments.json") as environments_file:
        environments_obj = json.loads(environments_file.read())
        environments = environments_obj["environments"]
        return environments


def deploy_environments(environments):
    for environment, environment_options in environments.items():
        target = environment_options["checkout"]
        print(f"Deploying '{environment}' using git target <{target}>")
        repo.git.checkout(target)
        


print(get_past_environments())
repo.git.checkout("main")
print(get_environments())
