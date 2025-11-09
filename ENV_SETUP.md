# Environment Variables Setup Guide

## Overview

This guide explains how to set up and manage environment variables for the bash_maintain project, specifically:

- `SPECIFY_FEATURE` - Override feature detection
- `GITHUB_TOKEN` - GitHub authentication token for corporate environments

## Quick Start

### 1. Create Your .env File

```bash
# Copy the example file
cp .env.example .env

# Edit with your values
nano .env
```

### 2. Configure Your Variables

Edit `.env` and replace the placeholder values:

```bash
# Specify which feature to work on
SPECIFY_FEATURE=001-photo-albums

# Your GitHub Personal Access Token
GITHUB_TOKEN=ghp_your_actual_token_here
```

### 3. Load the Variables

```bash
# Option A: Source the load script (recommended)
source scripts/load-env.sh

# Option B: Load directly
source .env
```

## Methods for Setting Environment Variables

### Method 1: Using .env File (Recommended)

**Best for**: Project-specific configuration that shouldn't be committed to git

```bash
# 1. Create .env file
cp .env.example .env

# 2. Edit the file
nano .env

# 3. Add your values
SPECIFY_FEATURE=001-photo-albums
GITHUB_TOKEN=ghp_your_token_here

# 4. Load into current shell
source scripts/load-env.sh
```

**Pros**:
- Secure (not committed to git)
- Easy to manage
- Project-specific

**Cons**:
- Must be sourced in each new shell session
- Not available to other terminals

### Method 2: Export in Current Shell (Temporary)

**Best for**: One-time use, testing, or temporary overrides

```bash
# Set for current shell session only
export SPECIFY_FEATURE=001-photo-albums
export GITHUB_TOKEN=ghp_your_token_here

# Verify they're set
echo $SPECIFY_FEATURE
echo $GITHUB_TOKEN
```

**Pros**:
- Quick and simple
- No file changes needed
- Session-specific

**Cons**:
- Lost when terminal closes
- Must re-export in each new session

### Method 3: Add to Shell Profile (Persistent)

**Best for**: Variables you always want available globally

#### For Bash (~/.bashrc or ~/.bash_profile)

```bash
# Edit your bash profile
nano ~/.bashrc

# Add these lines at the end
export SPECIFY_FEATURE=001-photo-albums
export GITHUB_TOKEN=ghp_your_token_here

# Reload your profile
source ~/.bashrc
```

#### For Zsh (~/.zshrc)

```bash
# Edit your zsh profile
nano ~/.zshrc

# Add these lines at the end
export SPECIFY_FEATURE=001-photo-albums
export GITHUB_TOKEN=ghp_your_token_here

# Reload your profile
source ~/.zshrc
```

**Pros**:
- Available in all new shell sessions
- Set once, use everywhere
- Survives system restarts

**Cons**:
- **SECURITY RISK**: Token visible in profile file
- Global to all projects
- Harder to change per-project

### Method 4: Shell-Specific Profile File

**Best for**: Different configurations for different shells

#### Create a dedicated environment file

```bash
# Create a dedicated env file
nano ~/.bash_maintain_env

# Add your variables
export SPECIFY_FEATURE=001-photo-albums
export GITHUB_TOKEN=ghp_your_token_here

# Source it from your .bashrc
echo "source ~/.bash_maintain_env" >> ~/.bashrc

# Reload
source ~/.bashrc
```

**Pros**:
- Organized and separate from main profile
- Easy to enable/disable
- Can be shared across shells

**Cons**:
- Still has security concerns for tokens
- Requires sourcing in profile

### Method 5: direnv (Advanced, Recommended for Multiple Projects)

**Best for**: Automatically loading .env when entering project directory

```bash
# Install direnv
sudo apt install direnv  # Debian/Ubuntu
brew install direnv      # macOS

# Add to your shell profile (~/.bashrc or ~/.zshrc)
eval "$(direnv hook bash)"  # for bash
eval "$(direnv hook zsh)"   # for zsh

# In project directory, allow direnv
cd /home/user/bash_maintain
direnv allow

# Create .envrc file (similar to .env)
echo 'export SPECIFY_FEATURE=001-photo-albums' > .envrc
echo 'export GITHUB_TOKEN=ghp_your_token_here' >> .envrc

# Make sure .envrc is in .gitignore
echo ".envrc" >> .gitignore
```

**Pros**:
- Automatically loads/unloads when entering/leaving directory
- Per-project configuration
- Supports multiple projects with different configs

**Cons**:
- Requires additional software installation
- Learning curve

## GitHub Token Setup

### Creating a GitHub Personal Access Token

1. **Go to GitHub Settings**:
   - Visit: https://github.com/settings/tokens
   - Or: Profile → Settings → Developer settings → Personal access tokens → Tokens (classic)

2. **Generate New Token**:
   - Click "Generate new token" → "Generate new token (classic)"
   - Name: `bash_maintain` or similar
   - Expiration: Choose based on security needs (90 days recommended)

3. **Select Scopes**:
   - ✅ `repo` - Full control of private repositories
   - ✅ `workflow` - Update GitHub Action workflows
   - ✅ `read:org` - Read organization data (if using org repos)

4. **Generate and Copy**:
   - Click "Generate token"
   - **IMPORTANT**: Copy the token immediately (you won't see it again!)
   - Format: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

5. **Store Securely**:
   ```bash
   # Add to .env file (NOT committed to git)
   echo "GITHUB_TOKEN=ghp_your_actual_token" >> .env

   # Or use a password manager
   # Or store in system keychain
   ```

### Using the Token

```bash
# Clone with token
git clone https://${GITHUB_TOKEN}@github.com/canstralian/bash_maintain.git

# Set remote with token
git remote set-url origin https://${GITHUB_TOKEN}@github.com/canstralian/bash_maintain.git

# Use with GitHub CLI
gh auth login --with-token <<< ${GITHUB_TOKEN}

# Use in API calls
curl -H "Authorization: token ${GITHUB_TOKEN}" \
  https://api.github.com/user
```

## Security Best Practices

### DO ✅

1. **Use .env files** for project-specific secrets
2. **Add .env to .gitignore** (already done in this project)
3. **Use .env.example** as a template without real values
4. **Rotate tokens regularly** (every 90 days)
5. **Use minimal scopes** for tokens
6. **Use environment-specific files** (.env.local, .env.production)
7. **Use password managers** or secret management tools

### DON'T ❌

1. **Never commit .env** files to git
2. **Never commit tokens** in shell profiles
3. **Never share tokens** in chat, email, or documentation
4. **Never use tokens** with full access when limited scopes work
5. **Never store tokens** in plaintext in shared locations
6. **Never log tokens** in application output

### Checking for Leaked Secrets

```bash
# Check if token is in git history
git log -S "ghp_" --all

# Check for .env in git
git ls-files | grep "^\.env$"

# Should return nothing if secure
```

## Verifying Your Setup

### Test Environment Variables

```bash
# Check if variables are set
env | grep SPECIFY_FEATURE
env | grep GITHUB_TOKEN

# Or use echo
echo "Feature: ${SPECIFY_FEATURE}"
echo "Token: ${GITHUB_TOKEN:0:10}..." # Show only first 10 chars

# Test in a script
cat > test-env.sh << 'EOF'
#!/bin/bash
if [[ -z "${SPECIFY_FEATURE}" ]]; then
    echo "❌ SPECIFY_FEATURE is not set"
else
    echo "✅ SPECIFY_FEATURE = ${SPECIFY_FEATURE}"
fi

if [[ -z "${GITHUB_TOKEN}" ]]; then
    echo "❌ GITHUB_TOKEN is not set"
else
    echo "✅ GITHUB_TOKEN is set (${#GITHUB_TOKEN} characters)"
fi
EOF

chmod +x test-env.sh
./test-env.sh
```

### Test GitHub Token

```bash
# Test token validity
curl -H "Authorization: token ${GITHUB_TOKEN}" \
  https://api.github.com/user | jq '.login'

# Should show your GitHub username

# Or use GitHub CLI
gh auth status
```

## Using in Scripts

### Example Script with Environment Variables

```bash
#!/usr/bin/env bash
# example-script.sh

set -euo pipefail

# Load environment variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/../.env" ]]; then
    source "${SCRIPT_DIR}/../.env"
fi

# Use the variables
echo "Working on feature: ${SPECIFY_FEATURE}"

# Make authenticated GitHub API call
curl -H "Authorization: token ${GITHUB_TOKEN}" \
  https://api.github.com/repos/canstralian/bash_maintain
```

### Example with Validation

```bash
#!/usr/bin/env bash
# validated-script.sh

set -euo pipefail

# Validate required environment variables
: "${SPECIFY_FEATURE:?Error: SPECIFY_FEATURE is not set}"
: "${GITHUB_TOKEN:?Error: GITHUB_TOKEN is not set}"

echo "Feature: ${SPECIFY_FEATURE}"
echo "Token: [REDACTED]"

# Continue with script logic...
```

## Troubleshooting

### Variables Not Set

```bash
# Check if .env exists
ls -la .env

# Check file contents (be careful with tokens!)
cat .env

# Source the file explicitly
source .env
source scripts/load-env.sh

# Check current shell variables
env | grep -E "(SPECIFY_FEATURE|GITHUB_TOKEN)"
```

### Token Authentication Fails

```bash
# Verify token format (should start with ghp_)
echo ${GITHUB_TOKEN} | head -c 4

# Check token scopes
curl -H "Authorization: token ${GITHUB_TOKEN}" \
  https://api.github.com/user | jq '.scopes'

# Test token validity
gh auth status

# Regenerate token if needed
# Go to https://github.com/settings/tokens
```

### Variables Not Persisting

```bash
# Make sure you're using 'source' or '.'
source .env        # Correct ✅
. .env            # Correct ✅
bash .env         # Wrong ❌ (runs in subshell)

# For permanent persistence, add to shell profile
echo 'source ~/path/to/bash_maintain/.env' >> ~/.bashrc
```

## Project-Specific Usage

### SPECIFY_FEATURE Variable

This variable overrides automatic feature detection:

```bash
# Set to work on a specific feature
export SPECIFY_FEATURE=001-photo-albums

# Or another feature
export SPECIFY_FEATURE=002-user-auth

# Check current feature
echo $SPECIFY_FEATURE
```

### Integration with Build Scripts

```bash
# scripts/build.sh might use it like:
if [[ -n "${SPECIFY_FEATURE}" ]]; then
    echo "Building feature: ${SPECIFY_FEATURE}"
    # Build only specified feature
else
    echo "Building all features"
    # Build everything
fi
```

## Quick Reference

```bash
# Create .env from example
cp .env.example .env

# Load environment variables
source scripts/load-env.sh

# Set temporarily (current session only)
export SPECIFY_FEATURE=001-photo-albums
export GITHUB_TOKEN=ghp_your_token

# Set permanently (add to ~/.bashrc)
echo 'export SPECIFY_FEATURE=001-photo-albums' >> ~/.bashrc
source ~/.bashrc

# Verify settings
env | grep -E "(SPECIFY_FEATURE|GITHUB_TOKEN)"

# Test GitHub token
gh auth status
```

## Additional Resources

- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [Environment Variables in Linux](https://www.digitalocean.com/community/tutorials/how-to-read-and-set-environmental-and-shell-variables-on-linux)
- [direnv Documentation](https://direnv.net/)
- [Best Practices for Managing Secrets](https://cloud.google.com/secret-manager/docs/best-practices)
