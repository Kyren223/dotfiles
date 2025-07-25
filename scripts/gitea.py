import os
import sys
import requests

from github import Github
from github import Auth

def read_token(var: str) -> str:
    path = os.getenv(var)
    if path is None:
        print(f"Missing env var: {var}", file=sys.stderr)
        sys.exit(1)
    return open(path).read().strip()

GITHUB_TOKEN: str = read_token("GITHUB_TOKEN_FILE")
GITHUB_USERNAME = "Kyren223"
GITEA_URL = "https://git.kyren.codes"
GITEA_TOKEN: str = read_token("GITEA_TOKEN_FILE")
GITEA_USER = "Kyren223"

success = 0
skipped = 0
failed = 0

def repo_exists(repo_name: str) -> bool:
    headers = {'Authorization': f'token {GITEA_TOKEN}'}
    r = requests.get(f'{GITEA_URL}/api/v1/repos/{GITEA_USER}/{repo_name}', headers=headers)
    return r.status_code == 200

def mirror(addr: str, repo_name: str):
    if repo_exists(repo_name):
        print(f"Skipping existing repo: {repo_name}")
        global skipped; skipped += 1
        return

    json = {
        'auth_token': GITHUB_TOKEN or '',
        'auth_username': GITHUB_USERNAME or '',
        'clone_addr': addr,
        'issues': True,
        'milestones': True,
        'mirror': True,
        'private': True,
        'pull_requests': True,
        'releases': True,
        'repo_name': repo_name,
        'repo_owner': GITEA_USER or '',
        'service': 'git',
        'uid': 0,
        'wiki': True
    }

    payload = { 'access_token': GITEA_TOKEN or '' }

    try:
        r = requests.post(f'{GITEA_URL}/api/v1/repos/migrate',
                      json=json, params=payload)
        r.raise_for_status()

        global success; success += 1
        print(f'Mirrored {repo_name}')
    except requests.exceptions.HTTPError as e:
        global failed; failed += 1
        print(f"Failed to mirror {repo_name}: {e}")

# using an access token
auth = Auth.Token(GITHUB_TOKEN or '')

# First create a Github instance:

# Public Web Github
g = Github(auth=auth)

# Then play with your Github objects:
for repo in g.get_user().get_repos():
    mirror(repo.clone_url, repo.name)

# To close connections after use
g.close()

print(f"\nSummary: {success} mirrored, {skipped} skipped, {failed} failed.")
