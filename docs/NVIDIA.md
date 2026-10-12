# NVIDIA support and provenance

Lokro does not compile or download an arbitrary display driver from a GitHub fork. NVIDIA publishes the open kernel-module source at `https://github.com/NVIDIA/open-gpu-kernel-modules`; Arch builds that source into signed `nvidia-open` packages matched to its stock `linux` kernel.

The default image uses Nouveau so it can boot broadly. In Calamares, users with Turing / GTX 16 / RTX 20 or newer hardware may select the official open NVIDIA stack. The offline image carries `nvidia-open`, `nvidia-utils`, `lib32-nvidia-utils` and resolved dependencies in a local Pacman repository. The online image obtains the same package names from the configured signed Arch repositories.

Pacman package archives already use zstd compression, and the ISO root filesystem is generated as zstd-compressed SquashFS. Double-wrapping driver packages would not materially reduce size and would prevent Pacman from installing them directly.

Maxwell, Pascal and older GPUs remain on Nouveau in v0.1. No legacy AUR package is selected automatically. Every release must test the installed kernel module after a full system upgrade because Arch and NVIDIA versions move together.
