# GitHub Setup and Configuration Guide

## Repository Information
- **Repository**: canstralian/bash_maintain
- **Current Branch**: claude/setup-commands-011CUwpD848UmaUJ4yTFukiP
- **Remote URL**: Uses local proxy configuration

## Initial Git Configuration

### Set Your Identity
```bash
# Configure globally (affects all repositories)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Or configure for this repository only
git config user.name "canstralian"
git config user.email "your.email@example.com"
```

### Verify Configuration
```bash
# View all configuration
git config --list

# View specific values
git config user.name
git config user.email
```

## Remote Repository Management

### View Remote Configuration
```bash
# Show remote repositories
git remote -v

# Show detailed information about origin
git remote show origin
```

### Update Remote URL (if needed)
```bash
# Use HTTPS
git remote set-url origin https://github.com/canstralian/bash_maintain.git

# Use SSH (recommended for authentication)
git remote set-url origin git@github.com:canstralian/bash_maintain.git
```

## SSH Authentication Setup

### Generate SSH Key
```bash
# Generate a new SSH key (Ed25519 algorithm - recommended)
ssh-keygen -t ed25519 -C "your.email@example.com"

# Or use RSA if Ed25519 is not supported
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"
```

### Add SSH Key to SSH Agent
```bash
# Start the ssh-agent
eval "$(ssh-agent -s)"

# Add your SSH private key
ssh-add ~/.ssh/id_ed25519  # or id_rsa for RSA keys
```

### Add SSH Key to GitHub
```bash
# Display your public key (copy this to GitHub)
cat ~/.ssh/id_ed25519.pub

# Or copy directly to clipboard (if xclip is installed)
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
```

Then:
1. Go to GitHub Settings → SSH and GPG keys
2. Click "New SSH key"
3. Paste your public key
4. Give it a descriptive title

### Test SSH Connection
```bash
ssh -T git@github.com
# Expected output: "Hi canstralian! You've successfully authenticated..."
```

## Branch Management

### Create and Switch Branches
```bash
# Create and switch to a new branch
git checkout -b feature/your-feature-name

# Or using newer syntax
git switch -c feature/your-feature-name

# Switch to existing branch
git checkout branch-name
git switch branch-name
```

### List Branches
```bash
# Local branches
git branch

# All branches (local and remote)
git branch -a

# Remote branches only
git branch -r
```

### Delete Branches
```bash
# Delete local branch (safe - prevents deletion of unmerged branches)
git branch -d branch-name

# Force delete local branch
git branch -D branch-name

# Delete remote branch
git push origin --delete branch-name
```

## Common Workflow Commands

### Check Status
```bash
# View status of working directory
git status

# Short format
git status -s
```

### Stage Changes
```bash
# Stage specific file
git add filename

# Stage all changes
git add .

# Stage all modified and deleted files (not new files)
git add -u

# Interactive staging
git add -p
```

### Commit Changes
```bash
# Commit with message
git commit -m "Your commit message"

# Commit with detailed message (opens editor)
git commit

# Stage and commit all tracked files
git commit -am "Your commit message"

# Amend last commit (change message or add files)
git commit --amend
```

### Push Changes
```bash
# Push to remote (first time for new branch)
git push -u origin branch-name

# Push to tracked remote branch
git push

# Force push (use with caution!)
git push --force-with-lease
```

### Pull Changes
```bash
# Pull from remote
git pull

# Pull from specific branch
git pull origin branch-name

# Pull with rebase instead of merge
git pull --rebase
```

### Fetch Updates
```bash
# Fetch all remotes
git fetch

# Fetch specific remote
git fetch origin

# Fetch and prune deleted remote branches
git fetch --prune
```

## View History

### Log Commands
```bash
# View commit history
git log

# One line per commit
git log --oneline

# Graph view
git log --oneline --graph --all

# Last N commits
git log -n 5

# Show commits from specific author
git log --author="canstralian"

# Show commits in date range
git log --since="2 weeks ago"
```

### Diff Commands
```bash
# Show unstaged changes
git diff

# Show staged changes
git diff --cached

# Compare branches
git diff main..feature-branch

# Show changes in specific file
git diff filename
```

## Stash Changes

```bash
# Stash current changes
git stash

# Stash with message
git stash save "Work in progress on feature X"

# List stashes
git stash list

# Apply most recent stash
git stash apply

# Apply and remove stash
git stash pop

# Apply specific stash
git stash apply stash@{0}

# Drop stash
git stash drop stash@{0}
```

## Undo Changes

### Discard Changes
```bash
# Discard changes in working directory
git restore filename

# Discard all changes
git restore .

# Unstage file (keep changes)
git restore --staged filename
```

### Reset Commits
```bash
# Soft reset (keep changes staged)
git reset --soft HEAD~1

# Mixed reset (keep changes unstaged) - default
git reset HEAD~1

# Hard reset (discard all changes) - DANGEROUS
git reset --hard HEAD~1
```

## Pull Requests

### Using GitHub Web Interface
1. Push your branch: `git push -u origin feature-branch`
2. Go to: https://github.com/canstralian/bash_maintain
3. Click "Compare & pull request"
4. Fill in title and description
5. Click "Create pull request"

### Quick PR Link
After pushing a branch, GitHub provides a direct link:
```
https://github.com/canstralian/bash_maintain/pull/new/branch-name
```

## Git Configuration Best Practices

```bash
# Set default branch name
git config --global init.defaultBranch main

# Set default push behavior
git config --global push.default current

# Enable color output
git config --global color.ui auto

# Set default pull strategy
git config --global pull.rebase false  # merge (default)
git config --global pull.rebase true   # rebase

# Cache credentials (HTTPS only)
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'

# Set default editor
git config --global core.editor "nano"  # or vim, code, etc.

# Enable autocorrect
git config --global help.autocorrect 10  # wait 1 second before running
```

## Useful Aliases

```bash
# Add helpful aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg "log --oneline --graph --all"
```

## Troubleshooting

### Authentication Issues
```bash
# Clear credential cache
git credential-cache exit

# Test connection
ssh -T git@github.com
```

### Push Rejected
```bash
# Pull changes first
git pull --rebase origin branch-name

# Then push
git push
```

### Merge Conflicts
```bash
# View conflicted files
git status

# After resolving conflicts
git add resolved-file
git commit

# Abort merge
git merge --abort
```

### Accidentally Committed to Wrong Branch
```bash
# On wrong branch: stash or note the commit hash
git log  # note the commit hash

# Switch to correct branch
git checkout correct-branch

# Cherry-pick the commit
git cherry-pick commit-hash

# Go back to wrong branch and remove the commit
git checkout wrong-branch
git reset --hard HEAD~1
```

## Quick Reference

### Essential Commands
```bash
git status                          # Check current state
git add .                           # Stage all changes
git commit -m "message"            # Commit changes
git push                           # Push to remote
git pull                           # Pull from remote
git branch                         # List branches
git checkout -b new-branch         # Create and switch branch
git log --oneline --graph          # View history
```

### Current Branch Workflow
```bash
# On claude/setup-commands-011CUwpD848UmaUJ4yTFukiP
git add .
git commit -m "Add GitHub setup documentation"
git push
```

## Additional Resources

- GitHub Docs: https://docs.github.com
- Git Documentation: https://git-scm.com/doc
- Pro Git Book: https://git-scm.com/book/en/v2
- GitHub Guides: https://guides.github.com

---

**Note**: This repository is configured with a local proxy for the remote. The actual GitHub repository is at:
`https://github.com/canstralian/bash_maintain`
