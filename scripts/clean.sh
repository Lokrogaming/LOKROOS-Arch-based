#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail
source "$(dirname "$0")/common.sh"
for target in "${BUILD_DIR}" "${OUT_DIR}"; do
    [[ "$target" == "${PROJECT_ROOT}/build" || "$target" == "${PROJECT_ROOT}/out" ]] || die "refusing to clean $target"
    rm -rf -- "$target"
done
