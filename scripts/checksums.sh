#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail
source "$(dirname "$0")/common.sh"
need sha256sum
need pacman
need bsdtar
need split
mkdir -p "$OUT_DIR"
repo_archive="$OUT_DIR/lokro-repo-${VERSION}.tar.zst"
[[ -d "$LOCAL_REPO_DIR" ]] || die 'local package repository is missing; run make packages first'
rm -f "$repo_archive" "${repo_archive}.sha256"
bsdtar -C "$LOCAL_REPO_DIR" -caf "$repo_archive" .
(cd "$OUT_DIR" && sha256sum "$(basename "$repo_archive")" > "$(basename "$repo_archive").sha256")
cp "${PROJECT_ROOT}/LOKRO_UPDATE_CHANNEL.json" "$OUT_DIR/LOKRO_UPDATE_CHANNEL.json"
mapfile -d '' -t iso_files < <(find "$OUT_DIR" -maxdepth 1 -type f -name '*.iso' -print0 | sort -z)
(( ${#iso_files[@]} > 0 )) || die 'no ISO found in out/'
sha256sum "${iso_files[@]}" "$repo_archive" > "$OUT_DIR/SHA256SUMS"
rm -f "$OUT_DIR"/*.iso.[0-9][0-9][0-9]
for iso in "${iso_files[@]}"; do
    split --bytes=1900M --numeric-suffixes=1 --suffix-length=3 "$iso" "${iso}."
done
mapfile -d '' -t iso_parts < <(find "$OUT_DIR" -maxdepth 1 -type f -name '*.iso.[0-9][0-9][0-9]' -print0 | sort -z)
(( ${#iso_parts[@]} > 0 )) || die 'ISO release parts were not generated'
sha256sum "${iso_parts[@]}" > "$OUT_DIR/ISO-PARTS-SHA256SUMS"
cat > "$OUT_DIR/REASSEMBLE.md" <<'EOF'
# LOKRO OS alpha download

GitHub requires every individual release file to be smaller than 2 GiB, so each ISO is published as numbered raw parts. Download every `.001`, `.002`, and following part for the chosen `offline` or `online` image into one folder.

Linux/macOS reconstruction (replace `VARIANT` and `VERSION` with the downloaded name):

```bash
cat lokro-os-VARIANT-VERSION-x86_64.iso.??? > lokro-os-VARIANT-VERSION-x86_64.iso
sha256sum -c SHA256SUMS --ignore-missing
```

Windows PowerShell reconstruction (replace the two file names first):

```powershell
$base = 'lokro-os-VARIANT-VERSION-x86_64.iso'
$output = [IO.File]::Create($base)
Get-ChildItem "$base.???" | Sort-Object Name | ForEach-Object {
    $input = [IO.File]::OpenRead($_.FullName)
    $input.CopyTo($output)
    $input.Dispose()
}
$output.Dispose()
Get-FileHash $base -Algorithm SHA256
```

Compare the resulting hash with the matching ISO line in `SHA256SUMS` before writing it to USB. This remains an experimental x86_64 alpha for virtual machines and test hardware, not a production or daily-driver release.
EOF
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
