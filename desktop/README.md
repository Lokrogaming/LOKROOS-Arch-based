# LOKRO OS Desktop

This directory identifies the private-computer/desktop edition. The buildable source remains at the repository root because Archiso, package recipes and CI workflows expect a shared project tree.

## Images

- **Offline:** complete KDE desktop, installer, office applications, language support and optional gaming/NVIDIA payload without requiring an internet connection during installation.
- **Online:** smaller USB image with a usable minimal offline installation; selected extra applications can be downloaded from signed Arch repositories when connectivity is available.

Both images target **x86_64 only** and boot on supported UEFI and legacy BIOS systems. Generated ISOs belong in GitHub Releases, not in the Git history.

See the root [`README.md`](../README.md) for build commands and [`docs/TESTING.md`](../docs/TESTING.md) before installing on real hardware.
