#!/usr/bin/env bash
# example_script.sh - Example bash script for testing bash_maintain
#
# Description:
#   A simple example script that demonstrates various Bash features
#
# Author: canstralian

set -euo pipefail

# Global variables
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function: greet
# Description: Greets the user
# Arguments:
#   $1 - Name of the person to greet
greet() {
    local name="${1:-World}"
    echo "Hello, $name!"
}

# Function: calculate_sum
# Description: Calculates the sum of two numbers
# Arguments:
#   $1 - First number
#   $2 - Second number
# Returns:
#   Sum of the two numbers
calculate_sum() {
    local num1="$1"
    local num2="$2"
    echo $((num1 + num2))
}

# Main execution
main() {
    echo "Running $SCRIPT_NAME"
    echo "Script directory: $SCRIPT_DIR"
    echo ""

    greet "Bash Maintain User"

    local result
    result=$(calculate_sum 5 10)
    echo "5 + 10 = $result"
}

# Execute main if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
