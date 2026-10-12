#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck disable=SC2034
BUILD_DIR="${PROJECT_ROOT}/build"
OUT_DIR="${PROJECT_ROOT}/out"
# shellcheck disable=SC2034
LOCAL_REPO_DIR="${OUT_DIR}/repo"
# shellcheck disable=SC2034
VERSION="$(tr -d '[:space:]' < "${PROJECT_ROOT}/VERSION")"

log() { printf '[lokro] %s\n' "$*"; }
die() { printf '[lokro] error: %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"; }

require_arch() {
    [[ -r /etc/arch-release ]] || die 'this command must run on Arch Linux'
}

enable_multilib() {
    local config="$1"
    if grep -Eq '^[[:space:]]*\[multilib\]' "$config"; then
        return 0
    fi
    cat >> "$config" <<'EOF'

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
}
