"""
deploy.py

Figure out the changes since the last commit on this branch that changed the
environment file.
"""
import os
import json
from git import Repo


repo = Repo(os.getcwd(), search_parent_directories=False)


with open("infra/environments.json") as environments_file:
    environments_obj = json.loads(environments_file.read())
    environments = environments_obj["environments"]
    for environment, environment_options in environments.items():
        target = environment_options["checkout"]
        print(f"Deploying '{environment}' using git target <{target}>")
        repo.git.checkout(target)
        print(list(os.listdir()))
        
