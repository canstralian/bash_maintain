#!/usr/bin/env bash
# Load environment variables from .env file
# Usage: source scripts/load-env.sh

set -euo pipefail

# Determine the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${PROJECT_ROOT}/.env"

# Function to load environment variables
load_env() {
    if [[ ! -f "${ENV_FILE}" ]]; then
        echo "Warning: .env file not found at ${ENV_FILE}"
        echo "Please copy .env.example to .env and configure your settings:"
        echo "  cp .env.example .env"
        return 1
    fi

    # Export variables from .env file
    # Ignore comments and empty lines
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "${key}" =~ ^#.*$ ]] && continue
        [[ -z "${key}" ]] && continue

        # Remove leading/trailing whitespace
        key=$(echo "${key}" | xargs)
        value=$(echo "${value}" | xargs)

        # Remove quotes if present
        value="${value%\"}"
        value="${value#\"}"
        value="${value%\'}"
        value="${value#\'}"

        # Export the variable
        export "${key}=${value}"
        echo "Loaded: ${key}"
    done < "${ENV_FILE}"

    echo "Environment variables loaded from ${ENV_FILE}"
}

# Run the function
load_env
