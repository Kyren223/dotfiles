# Make sure my ssh key is loaded in ssh-agent for use when committing
eval $(keychain --quiet --eval $HOME/.ssh/id_ed25519)

REPOS=(
    "$HOME/personal/dairy"
    "/path/to/repo2"
    "/path/to/repo3"
)

COMMIT_MSG="Auto-sync: $(date +'%Y-%m-%d %H:%M:%S')"

success_count=0
failure_count=0
failed_repos=()

sync_repo() {
    local repo_path="$1"
    echo "Syncing $repo_path..."

    cd "$repo_path" || { 
        echo "Failed to access $repo_path"
        failed_repos+=("$repo_path")
        ((failure_count++))
        return
    }

    # Ensure it's a git repo
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "$repo_path is not a valid Git repo"
        echo "Current directory: $(pwd)"
        git status || echo "Git status failed in $repo_path"
        failed_repos+=("$repo_path")
        ((failure_count++))
        return
    fi

    if git diff --quiet; then
        echo "No unstaged changes in $repo_path"
    else
        echo "Committing changes in $repo_path..."
        git add -A
        if ! git commit -m "$COMMIT_MSG"; then
            echo "Failed to commit changes in $repo_path"
            failed_repos+=("$repo_path")
            ((failure_count++))
            return
        fi
    fi

    if ! git pull --rebase; then
        if [[ $(git status --porcelain) == "" ]]; then
            echo "No changes to pull in $repo_path"
        else
            echo "Failed to pull changes in $repo_path"
            failed_repos+=("$repo_path")
            ((failure_count++))
            return
        fi
    fi

    if ! git push; then
        echo "Failed to push changes in $repo_path"
        failed_repos+=("$repo_path")
        ((failure_count++))
        return
    fi

    echo "$repo_path synced successfully"
    ((success_count++))
}

# Iterate through each repo
for repo in "${REPOS[@]}"; do
    sync_repo "$repo"
done

# Output results
echo "Sync completed! $success_count succeeded, $failure_count failed, ${#REPOS[@]} total."

# Check if any repositories partially failed
if [[ $failure_count -gt 0 ]]; then
    echo "Failed repos:"
    for repo in "${failed_repos[@]}"; do
        echo "  - $repo"
    done
fi
