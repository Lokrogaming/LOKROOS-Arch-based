#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail

recipes=(
    vendor/calamares
    packages/lokro-branding
    packages/lokro-shell
    packages/lokro-installer-config
    packages/lokro-ai-setup
)

for recipe in "${recipes[@]}"; do
    if (( EUID == 0 )); then
        (
            cd "$recipe"
            runuser -u nobody -- env HOME=/tmp makepkg --printsrcinfo >/dev/null
        )
    else
        (cd "$recipe" && makepkg --printsrcinfo >/dev/null)
    fi
done
