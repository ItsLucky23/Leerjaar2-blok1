#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
dotnet build Opdracht.csproj --nologo >/dev/null

check() {
    local input="$1" expected="$2" actual
    # A sentinel preserves the program's trailing newlines in command substitution.
    actual=$(printf '%s\n' "$input" | dotnet bin/Debug/net8.0/Opdracht.dll && printf '\034')
    actual=${actual%$'\034'}
    expected+=$'\n'
    if [[ "$actual" != "$expected" ]]; then
        printf 'FAIL: input %q: expected %q, got %q\n' "$input" "$expected" "$actual" >&2
        exit 1
    fi
}

check '1' 'typ een nummer: BOEM!!'
check '2' 'typ een nummer: dat was geen 1'
check '' 'typ een nummer: dat was geen 1'
printf 'Smoke tests passed.\n'
