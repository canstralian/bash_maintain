# Quick Environment Setup

## 3-Step Setup (Recommended)

### Step 1: Create .env file
```bash
cp .env.example .env
```

### Step 2: Edit with your values
```bash
nano .env
```

Replace these lines:
```bash
SPECIFY_FEATURE=001-photo-albums
GITHUB_TOKEN=ghp_your_actual_token_here
```

### Step 3: Load variables
```bash
source scripts/load-env.sh
```

---

## Alternative: Temporary Setup (Quick Test)

Just run these two commands:

```bash
export SPECIFY_FEATURE=001-photo-albums
export GITHUB_TOKEN=ghp_your_token_here
```

**Note**: This only lasts until you close the terminal.

---

## Alternative: Permanent Setup (All Sessions)

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# For bash
echo 'export SPECIFY_FEATURE=001-photo-albums' >> ~/.bashrc
echo 'export GITHUB_TOKEN=ghp_your_token_here' >> ~/.bashrc
source ~/.bashrc

# For zsh
echo 'export SPECIFY_FEATURE=001-photo-albums' >> ~/.zshrc
echo 'export GITHUB_TOKEN=ghp_your_token_here' >> ~/.zshrc
source ~/.zshrc
```

⚠️ **Security Warning**: Only do this on your personal machine!

---

## Getting a GitHub Token

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scopes: `repo`, `workflow`
4. Copy the token (starts with `ghp_`)
5. Use it in your .env file

---

## Verify Setup

```bash
# Check if variables are set
echo "Feature: $SPECIFY_FEATURE"
echo "Token: ${GITHUB_TOKEN:0:10}..."

# Test GitHub authentication
gh auth status
```

---

## Need More Details?

See `ENV_SETUP.md` for comprehensive documentation.
