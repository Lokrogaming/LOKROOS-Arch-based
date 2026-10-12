# Third-party notices

Lokro OS combines unmodified or configured upstream software. Every installed package retains the license and source metadata provided by Arch Linux or its upstream project.

Key upstream projects include Arch Linux and Archiso, KDE Plasma and KDE Gear, Calamares, GNU GRUB, Linux, Mesa, Flatpak, LibreOffice, Firefox, Ollama and OpenCode. Calamares is built from the versioned upstream archive whose SHA-256 digest is pinned in `vendor/calamares/PKGBUILD`; Ollama downloads are pinned in `/usr/share/lokro-ai/releases.json` and verified before extraction. OpenCode is installed on request from Arch's signed `extra` repository.

NVIDIA support is delivered through Arch's signed `nvidia-open`, `nvidia-utils` and `lib32-nvidia-utils` packages. The kernel module upstream is NVIDIA's `open-gpu-kernel-modules` project; Lokro does not redistribute an unofficial driver build. CachyOS was reviewed as a performance and installer reference. No CachyOS binary repository, kernel or configuration package is redistributed by Lokro v0.1.

Original Lokro scripts, QML and configuration use `GPL-3.0-or-later`. Original SVG artwork uses `CC-BY-SA-4.0`. This notice does not relicense upstream works.
