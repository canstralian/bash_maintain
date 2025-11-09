#!/usr/bin/env bash
# install.sh - Installation script for Bash Maintain
#
# Description:
#   Installs bash_maintain toolkit
#
# Author: canstralian

set -euo pipefail

readonly INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Bash Maintain Installation"
echo "=========================="
echo ""

# Check for required commands
check_requirements() {
    local missing=()

    if ! command -v bash &> /dev/null; then
        missing+=("bash")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Error: Missing required commands: ${missing[*]}"
        exit 1
    fi

    echo "✓ Requirements check passed"
}

# Install the main script
install_script() {
    echo "Installing bash_maintain to $INSTALL_DIR..."

    if [[ ! -w "$INSTALL_DIR" ]]; then
        echo "Error: No write permission to $INSTALL_DIR"
        echo "Try running with sudo or set INSTALL_DIR to a writable location"
        exit 1
    fi

    cp "$PROJECT_ROOT/src/bash_maintain.sh" "$INSTALL_DIR/bash_maintain"
    chmod +x "$INSTALL_DIR/bash_maintain"

    echo "✓ Installation complete"
}

# Main installation
main() {
    check_requirements
    install_script

    echo ""
    echo "Bash Maintain has been installed successfully!"
    echo "Run 'bash_maintain help' to get started."
}

main "$@"
