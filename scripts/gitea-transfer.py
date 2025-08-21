import os
import sys
import requests

def read_token(var: str) -> str:
    path = os.getenv(var)
    if path is None:
        print(f"Missing env var: {var}", file=sys.stderr)
        sys.exit(1)
    return path.strip()

GITEA_TOKEN: str = read_token("GITEA_TOKEN_FILE")
GITEA_URL = "https://git.kyren.codes"
GITEA_USER = "kyren223"
TARGET_USER = "archive"

success = 0
skipped = 0
failed = 0

def repo_exists(repo_name: str) -> bool:
    headers = {'Authorization': f'token {GITEA_TOKEN}'}
    r = requests.get(f'{GITEA_URL}/api/v1/repos/{TARGET_USER}/{repo_name}', headers=headers)
    return r.status_code == 200

def transfer_ownership(repo_name: str):
    if repo_exists(repo_name):
        print(f"Skipping existing repo: {repo_name}")
        global skipped; skipped += 1
        return

    headers = {
        'Authorization': f'token {GITEA_TOKEN}',
        'Content-Type': 'application/json'
    }
    json = {"new_owner": TARGET_USER}

    try:
        r = requests.post(f'{GITEA_URL}/api/v1/repos/{GITEA_USER}/{repo_name}/transfer', headers=headers, json=json)
        r.raise_for_status()

        global success; success += 1
        print(f'Transferred {repo_name}')
    except requests.exceptions.HTTPError as e:
        global failed; failed += 1
        print(f"Failed to transfer {repo_name}: {e}")

headers = {'Authorization': f'token {GITEA_TOKEN}'}
response = requests.get(f'{GITEA_URL}/api/v1/users/{GITEA_USER}/repos', headers=headers)
if response.status_code != 200:
    print(f"Failed to list repos: {response.text}")
    sys.exit(1)
repos = response.json()

for repo in repos:
    transfer_ownership(repo['name'])

print(f"\nSummary: {success} transferred, {skipped} skipped, {failed} failed.")
