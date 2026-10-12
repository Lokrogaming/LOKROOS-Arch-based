# Dependency and source policy

1. Base-system software comes from signed official Arch repositories.
2. Lokro-owned packages are built locally and placed in the ISO-local repository.
3. Calamares is built from a versioned upstream archive with a pinned SHA-256 digest.
4. NVIDIA's open kernel driver is consumed through Arch's signed packages. Those package archives are already zstd-compressed; wrapping them in another archive would save almost nothing and make offline installation harder.
5. Optional Ollama archives are version- and checksum-pinned and are never downloaded without an explicit user action.
6. AUR packages, curl-to-shell installers and unverified GitHub release binaries are forbidden in the default build.
7. The online ISO may download only from repositories present in its Pacman configuration and from Flathub after installation.
8. Every ISO records the exact resolved package versions and installed-package licenses.
