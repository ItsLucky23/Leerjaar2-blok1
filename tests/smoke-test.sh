#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
if ! build_log=$(dotnet build Opdracht.csproj --nologo 2>&1); then
    printf '%s\n' "$build_log" >&2
    printf 'FAIL: build failed\n' >&2
    exit 1
fi

# Runs the program with the given stdin and compares its full output.
run_check() {
    local label="$1" expected="$2" actual
    # A sentinel preserves the program's trailing newlines in command substitution.
    if ! actual=$(dotnet run --no-build --project Opdracht.csproj && printf '\034'); then
        printf 'FAIL: %s: program crashed\n' "$label" >&2
        exit 1
    fi
    actual=${actual%$'\034'}
    # Windows ends lines with \r\n.
    actual=${actual//$'\r'/}
    expected+=$'\n'
    if [[ "$actual" != "$expected" ]]; then
        printf 'FAIL: %s: expected %q, got %q\n' "$label" "$expected" "$actual" >&2
        exit 1
    fi
}

check() {
    printf '%s\n' "$1" | run_check "input $(printf '%q' "$1")" "$2"
}

check '1' 'typ een nummer: BOEM!!'
check ' 1 ' 'typ een nummer: BOEM!!'
check '01' 'typ een nummer: BOEM!!'
check '2' 'typ een nummer: dat was geen 1'
check 'abc' 'typ een nummer: dat is geen nummer'
check '' 'typ een nummer: dat is geen nummer'
run_check 'end of input' 'typ een nummer: geen invoer' </dev/null
printf 'Smoke tests passed.\n'
