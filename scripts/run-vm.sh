#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail
source "$(dirname "$0")/common.sh"
need qemu-system-x86_64
mode="${1:-bios}"
variant="${2:-offline}"
[[ "$variant" == offline || "$variant" == online ]] || die 'variant must be offline or online'
iso="$(find "${OUT_DIR}" -maxdepth 1 -type f -name "*${variant}*.iso" -printf '%T@ %p\n' | sort -nr | head -n1 | cut -d' ' -f2-)"
[[ -n "$iso" ]] || die 'no ISO found in out/'

args=(-enable-kvm -m 4096 -smp 4 -device virtio-vga-gl -display gtk,gl=on -cdrom "$iso" -boot d)
if [[ "$mode" == uefi ]]; then
    ovmf=/usr/share/edk2/x64/OVMF_CODE.4m.fd
    [[ -f "$ovmf" ]] || ovmf=/usr/share/edk2-ovmf/x64/OVMF_CODE.fd
    [[ -f "$ovmf" ]] || die 'OVMF firmware not found'
    args+=(-drive "if=pflash,format=raw,readonly=on,file=$ovmf")
elif [[ "$mode" != bios ]]; then
    die 'usage: run-vm.sh bios|uefi [offline|online]'
fi
exec qemu-system-x86_64 "${args[@]}"
