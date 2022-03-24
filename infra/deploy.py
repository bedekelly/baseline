"""
deploy.py

Figure out the changes since the last commit on this branch that changed the
environment file.
"""
import os
from git import Repo

repo = Repo(os.getcwd())

print(repo)
