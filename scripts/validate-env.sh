#!/usr/bin/env bash
# Validate environment variables are set correctly
# Usage: ./scripts/validate-env.sh

set -euo pipefail

echo "=== Environment Variables Validation ==="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track validation status
ERRORS=0

# Function to check a variable
check_var() {
    local var_name=$1
    local var_value="${!var_name:-}"

    if [[ -z "${var_value}" ]]; then
        echo -e "${RED}❌ ${var_name} is NOT set${NC}"
        ((ERRORS++))
        return 1
    else
        echo -e "${GREEN}✅ ${var_name} is set${NC}"
        return 0
    fi
}

# Function to validate GitHub token format
validate_github_token() {
    local token="${GITHUB_TOKEN:-}"

    if [[ -z "${token}" ]]; then
        echo -e "${RED}❌ GITHUB_TOKEN is not set${NC}"
        ((ERRORS++))
        return 1
    fi

    if [[ ! "${token}" =~ ^ghp_ ]]; then
        echo -e "${YELLOW}⚠️  GITHUB_TOKEN doesn't start with 'ghp_' (might be invalid)${NC}"
        echo -e "${YELLOW}   Expected format: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx${NC}"
        ((ERRORS++))
    fi

    local token_length=${#token}
    if [[ ${token_length} -lt 40 ]]; then
        echo -e "${YELLOW}⚠️  GITHUB_TOKEN seems too short (${token_length} chars)${NC}"
        echo -e "${YELLOW}   Expected length: 40+ characters${NC}"
        ((ERRORS++))
    else
        echo -e "${GREEN}✅ GITHUB_TOKEN format looks valid (${token_length} chars)${NC}"
    fi
}

# Check required variables
echo "Checking required environment variables:"
echo ""

check_var "SPECIFY_FEATURE"
if [[ $? -eq 0 ]]; then
    echo "   Value: ${SPECIFY_FEATURE}"
fi
echo ""

check_var "GITHUB_TOKEN"
if [[ $? -eq 0 ]]; then
    echo "   Value: ${GITHUB_TOKEN:0:10}... (truncated for security)"
    echo ""
    validate_github_token
fi
echo ""

# Check .env file exists
echo "Checking configuration files:"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [[ -f "${PROJECT_ROOT}/.env" ]]; then
    echo -e "${GREEN}✅ .env file exists${NC}"
    echo "   Location: ${PROJECT_ROOT}/.env"
else
    echo -e "${YELLOW}⚠️  .env file not found${NC}"
    echo "   Expected: ${PROJECT_ROOT}/.env"
    echo "   Hint: Copy from .env.example"
    echo "   Command: cp .env.example .env"
    ((ERRORS++))
fi
echo ""

if [[ -f "${PROJECT_ROOT}/.env.example" ]]; then
    echo -e "${GREEN}✅ .env.example file exists${NC}"
else
    echo -e "${RED}❌ .env.example file not found${NC}"
    ((ERRORS++))
fi
echo ""

# Test GitHub authentication if token is set
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    echo "Testing GitHub authentication:"
    echo ""

    # Test with curl
    RESPONSE=$(curl -s -w "%{http_code}" -H "Authorization: token ${GITHUB_TOKEN}" \
        https://api.github.com/user -o /tmp/gh_user_response.json)

    if [[ "${RESPONSE}" == "200" ]]; then
        USERNAME=$(jq -r '.login' /tmp/gh_user_response.json 2>/dev/null || echo "unknown")
        echo -e "${GREEN}✅ GitHub token is valid${NC}"
        echo "   Authenticated as: ${USERNAME}"
    elif [[ "${RESPONSE}" == "401" ]]; then
        echo -e "${RED}❌ GitHub token is invalid or expired${NC}"
        echo "   HTTP Status: 401 Unauthorized"
        ((ERRORS++))
    else
        echo -e "${YELLOW}⚠️  Could not verify GitHub token${NC}"
        echo "   HTTP Status: ${RESPONSE}"
        echo "   This might be a network issue"
    fi

    rm -f /tmp/gh_user_response.json
    echo ""
fi

# Summary
echo "=== Validation Summary ==="
echo ""

if [[ ${ERRORS} -eq 0 ]]; then
    echo -e "${GREEN}✅ All validations passed!${NC}"
    echo ""
    echo "You're ready to use these environment variables."
    exit 0
else
    echo -e "${RED}❌ Found ${ERRORS} issue(s)${NC}"
    echo ""
    echo "Please fix the issues above before continuing."
    echo "See ENV_SETUP.md for detailed setup instructions."
    exit 1
fi
