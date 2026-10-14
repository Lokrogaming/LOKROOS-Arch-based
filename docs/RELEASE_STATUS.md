# LOKRO OS 0.1.0-alpha.4 release status

This file separates implemented source from tested release claims. An item being configured does not prove that it works on every physical computer.

## Implemented in the source tree

- x86_64-only Archiso desktop images, based on the official releng profile.
- KDE Plasma 6 Wayland desktop with XWayland compatibility and SDDM login.
- Calamares installation flow for locale, keyboard, partitioning, user accounts, package choices and GRUB.
- Installer choices for Plasma/optional Hyprland, Firefox/no browser, application bundle, graphics path and gaming bundle.
- Fully embedded Arch base, kernel and firmware; no pre-installed operating system is required.
- UEFI and legacy BIOS boot configuration; GPT/ext4 default, manual partitioning and optional LUKS encryption.
- Pacman base-system management plus Flatpak, Flathub setup and KDE Discover.
- NetworkManager, Wi-Fi database and iwd tooling, LAN support through the Linux kernel, Bluetooth, USB utilities, Thunderbolt tooling and current Arch firmware packages.
- Mesa/OpenGL, AMD/Intel/Nouveau Vulkan and video acceleration. The offline installer can optionally install `nvidia-open`, `nvidia-utils` and `lib32-nvidia-utils` for supported Turing-or-newer NVIDIA hardware.
- PipeWire audio, power management, ZRAM, KDE settings, theming and desktop widgets.
- Plasma System Monitor exposed as the LOKRO Task Manager, KRunner/Baloo global search, searchable power/update actions, cursor settings and an optional Hyprland tiling session.
- Firefox, LibreOffice, Dolphin, Kate, Konsole, Okular, Ark, Gwenview, Spectacle, Haruna, KDE Connect and Flatseal in the offline payload.
- Optional Steam, Prism Launcher, Java 8/17/21, GameMode, Gamescope and MangoHud installation from the offline media.
- Separate offline and smaller online profiles, release checksums, manifests, provenance and license reports.
- Boot-time and five-hour update checks with low resource priority, safe pre-download, local confirmation, recovery metadata backups and running-kernel module retention.

## Static checks completed on the Windows development workspace

- Repository/configuration invariants and package-presence checks.
- JSON parsing and LOKRO service merge unit tests.
- YAML parsing, including Calamares and GitHub Actions files.
- Shell syntax parsing.
- Git whitespace checks.

QML linting and PKGBUILD parsing are enforced in the Arch build workflow, where the required Arch/KDE tools are available.

## Required before sharing an ISO as tested

- Build both images on Arch Linux or in the privileged Arch GitHub Actions container.
- Complete automated BIOS and UEFI Plasma smoke boots.
- Install with Calamares into an empty VM and boot the installed disk without the ISO.
- Test manual partitioning and install-alongside behavior using backed-up disposable disks.
- Verify networking, audio, Bluetooth, suspend, multi-monitor, Flatpak installation and a full Pacman update.
- Test at least one AMD GPU machine, one supported NVIDIA Turing-or-newer machine with `nvidia-open`, and the Nouveau fallback.
- Verify Minecraft with Prism Launcher and Steam/Proton on hardware. Compatibility depends on each game, anti-cheat system and GPU driver.

## Not part of this alpha

- A server edition (the `server/` directory is only a placeholder).
- Secure Boot, guaranteed dual boot, guaranteed support for every peripheral, or automatic proprietary legacy NVIDIA drivers.
- A custom package server, custom desktop environment, LibreOffice fork or bundled AI model.
- General-purpose live kernel replacement. The running kernel remains active until reboot; only its matching modules are retained safely.

Until the required build and boot jobs pass, publish source archives only and do not label a locally absent ISO as downloadable.
