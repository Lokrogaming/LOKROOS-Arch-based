#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail
source "$(dirname "$0")/common.sh"
need sha256sum
need pacman
mkdir -p "$OUT_DIR"
mapfile -d '' -t iso_files < <(find "$OUT_DIR" -maxdepth 1 -type f -name '*.iso' -print0 | sort -z)
(( ${#iso_files[@]} > 0 )) || die 'no ISO found in out/'
sha256sum "${iso_files[@]}" > "$OUT_DIR/SHA256SUMS"
for variant in offline online; do
    installed_root="${BUILD_DIR}/archiso-work-${variant}/x86_64/airootfs"
    manifest="$OUT_DIR/package-manifest-${variant}.txt"
    licenses="$OUT_DIR/package-licenses-${variant}.tsv"
    if [[ -d "$installed_root/var/lib/pacman/local" ]]; then
        LC_ALL=C pacman --root "$installed_root" --dbpath /var/lib/pacman -Q | sort > "$manifest"
        LC_ALL=C pacman --root "$installed_root" --dbpath /var/lib/pacman -Qi | awk '
            /^Name[[:space:]]*:/ { sub(/^[^:]*:[[:space:]]*/, ""); name=$0 }
            /^Version[[:space:]]*:/ { sub(/^[^:]*:[[:space:]]*/, ""); version=$0 }
            /^Licenses[[:space:]]*:/ { sub(/^[^:]*:[[:space:]]*/, ""); print name "\t" version "\t" $0 }
        ' | sort > "$licenses"
    elif [[ -f "$OUT_DIR/resolved-packages-${variant}.txt" ]]; then
        cp "$OUT_DIR/resolved-packages-${variant}.txt" "$manifest"
        printf '%s\n' 'Full installed-root license data is generated after a successful ISO build.' > "$licenses"
    fi
done
printf 'lokro_version=%s\nbuild_date=%s\narchiso_version=%s\nvariants=offline,online\n' \
    "$VERSION" "$(date -u +%FT%TZ)" "$(pacman -Q archiso 2>/dev/null | awk '{print $2}')" \
    > "$OUT_DIR/build-metadata.txt"
cp "${PROJECT_ROOT}/docs/THIRD_PARTY.md" "$OUT_DIR/THIRD_PARTY-NOTICES.md"
cp "${PROJECT_ROOT}/docs/KNOWN_LIMITATIONS.md" "$OUT_DIR/KNOWN_LIMITATIONS.md"
cp "${PROJECT_ROOT}/licenses/README.md" "$OUT_DIR/LICENSE-REFERENCES.md"
cp "${PROJECT_ROOT}/docs/AI_DISCLOSURE.md" "$OUT_DIR/AI-DISCLOSURE.md"
cp "${PROJECT_ROOT}/third_party/sources.json" "$OUT_DIR/SOURCE-PROVENANCE.json"
log 'release metadata generated'
