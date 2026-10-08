#!/usr/bin/env bash
set -u

PASS=0
FAIL=0

pass() { echo "PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "FAIL: $1"; FAIL=$((FAIL+1)); }

echo "======================================"
echo " Student Test Suite - Diagnostic CLI"
echo "======================================"

DIAG="./app/diagnostic.sh"

if [ ! -f "$DIAG" ]; then
  echo "ERROR: $DIAG not found!"
  exit 1
fi

# Test 1: Help command
"$DIAG" help >/dev/null 2>&1
[[ $? -eq 0 ]] && pass "help command returns exit code 0" || fail "help command failed"

# Test 2: System command
"$DIAG" system >/dev/null 2>&1
[[ $? -eq 0 ]] && pass "system command returns exit code 0" || fail "system command failed"

# Test 3: Disk command
"$DIAG" disk >/dev/null 2>&1
[[ $? -eq 0 ]] && pass "disk command returns exit code 0" || fail "disk command failed"

# Test 4: Network command with localhost
"$DIAG" network localhost >/dev/null 2>&1
rc=$?
[[ $rc -eq 0 || $rc -eq 1 ]] && pass "network command accepts host" || fail "network command failed"

# Test 5: Network command missing host
"$DIAG" network >/dev/null 2>&1
[[ $? -eq 2 ]] && pass "network command rejects missing host with exit code 2" || fail "network command should reject missing host with exit code 2"

# Test 6: Invalid command
"$DIAG" invalid-cmd >/dev/null 2>&1
[[ $? -eq 2 ]] && pass "invalid command returns exit code 2" || fail "invalid command should return exit code 2"

echo "======================================"
echo "Passed: $PASS | Failed: $FAIL"
echo "======================================"

[[ $FAIL -eq 0 ]]
