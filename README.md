# Lokro OS

Lokro OS is an experimental, Arch-based x86_64 desktop distribution built around KDE Plasma 6, Wayland, Pacman and Flatpak. Version `0.1.0-alpha.1` is intended for virtual machines and test hardware, not production systems.

Lokro OS is **64-bit only**. It does not ship a 32-bit kernel or a 32-bit ISO. The enabled Arch `multilib` repository supplies selected 32-bit compatibility libraries required by Steam and older games on the 64-bit system.

The repository contains two Archiso profiles, four Lokro packages, a pinned Calamares build recipe, a black-and-white Plasma theme, an animated dot-and-slash wallpaper, a first-run welcome center, the Lokro Hub widget, offline NVIDIA and gaming package paths, and an optional local-AI setup tool.

The `offline` image contains the application and German-language payload. The smaller `online` image offers a minimal offline fallback or downloads the selected application payload from signed Arch repositories. Both images contain Firefox, Pacman, Flatpak, Plasma and the installer. Steam/Prism Launcher support is an explicit optional installer choice.

## Repository layout

- [`desktop/`](desktop/) describes the desktop/private-computer edition. Its buildable source lives at the repository root so Archiso, package and CI paths remain conventional.
- [`server/`](server/) is a reserved, documentation-only placeholder. No server image is implemented or advertised yet.
- GitHub Releases holds generated ISOs and checksums. Large ISO binaries are deliberately not committed to Git.

## Downloads

There is no trusted public ISO until the GitHub build has completed successfully. Run the **Build alpha ISO** workflow with `publish_release` enabled; it builds both variants, performs BIOS and UEFI Plasma smoke boots, checks the 4 GiB size limit, and only then creates an alpha prerelease.

Expected release assets:

- `lokro-os-offline-0.1.0-alpha.1-x86_64.iso` — full offline application payload.
- `lokro-os-online-0.1.0-alpha.1-x86_64.iso` — smaller image with a minimal offline fallback and optional network downloads.
- `SHA256SUMS`, package manifests, license inventory, provenance and known limitations.

## Build host

The ISO must be built on Arch Linux (a VM is fine), as root, with at least 20 GiB free space. Windows can edit and validate the repository, but cannot run `mkarchiso` natively.

```bash
sudo pacman -Syu --needed base-devel archiso git jq nodejs qemu-desktop edk2-ovmf shellcheck
make validate
make packages
sudo make iso-offline
sudo make iso-online
make checksums
```

Artifacts are written to `out/`. Package builds use official Arch repositories plus a versioned Calamares source archive pinned by SHA-256. No AUR helper is installed or used at runtime.

## Developer interface

- `make validate` — static repository checks and ShellCheck when available.
- `make packages` — build Calamares and the four Lokro packages, then create a local repository.
- `sudo make iso` / `sudo make iso-offline` — build the complete offline image.
- `sudo make iso-online` — build the smaller network installer.
- `make vm-bios` / `make vm-uefi` — boot the newest ISO in QEMU.
- `make smoke-bios` / `make smoke-uefi` — wait for a readiness marker emitted by the live Plasma session.
- `make checksums` — create SHA-256 sums and a package manifest.

See [Release status](docs/RELEASE_STATUS.md), [Architecture](docs/ARCHITECTURE.md), [Gaming](docs/GAMING.md), [Hardware](docs/HARDWARE.md), [Dual boot](docs/DUAL_BOOT.md), [Testing](docs/TESTING.md), and [Known limitations](docs/KNOWN_LIMITATIONS.md).

## License

Original code and configuration are GPL-3.0-or-later. Original artwork is CC-BY-SA-4.0. Upstream components keep their own licenses; see [third-party notices](docs/THIRD_PARTY.md).

The project is openly AI-assisted; generated and reviewed areas are documented in [AI disclosure](docs/AI_DISCLOSURE.md). No release is represented as hand-written-only work.

Project credits are listed in [CONTRIBUTORS.md](CONTRIBUTORS.md).
