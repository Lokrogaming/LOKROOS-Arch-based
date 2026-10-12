#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_arch
(( EUID == 0 )) || die 'ISO build must run as root'
need mkarchiso

variant="${1:-offline}"
[[ "$variant" == offline || "$variant" == online ]] || die 'variant must be offline or online'

[[ -f "${LOCAL_REPO_DIR}/lokro.db.tar.zst" ]] || die 'run make packages first'
bash "${PROJECT_ROOT}/scripts/prepare-profile.sh" "$variant"
work_dir="${BUILD_DIR}/archiso-work-${variant}"
profile_dir="${BUILD_DIR}/profile-${variant}"
mkdir -p "${OUT_DIR}" "$work_dir"
rm -rf "$work_dir"/*
log "building Lokro OS ${VERSION} (${variant})"
mkarchiso -v -w "$work_dir" -o "${OUT_DIR}" "$profile_dir" \
    2>&1 | tee "${OUT_DIR}/build-${variant}-${VERSION}.log"
