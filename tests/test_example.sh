#!/usr/bin/env bash
# test_example.sh - Example test file
#
# Description:
#   Example test suite for bash_maintain
#
# Author: canstralian

set -euo pipefail

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Assert equals
assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-}"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ "$expected" == "$actual" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "✓ PASS: $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "✗ FAIL: $message"
        echo "  Expected: $expected"
        echo "  Actual:   $actual"
        return 1
    fi
}

# Test: Example test
test_example() {
    assert_equals "5" "5" "Numbers should be equal"
    assert_equals "hello" "hello" "Strings should match"
}

# Run all tests
run_tests() {
    echo "Running tests..."
    echo ""

    test_example

    echo ""
    echo "Tests run: $TESTS_RUN"
    echo "Passed: $TESTS_PASSED"
    echo "Failed: $TESTS_FAILED"

    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo "All tests passed!"
        return 0
    else
        echo "Some tests failed!"
        return 1
    fi
}

# Execute tests if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_tests
fi
