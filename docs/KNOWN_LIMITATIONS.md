# Known limitations — 0.1.0-alpha.1

- This is an alpha for test machines. Secure Boot and guaranteed dual-boot are not supported.
- LUKS1 encryption is available but remains experimental until BIOS and UEFI installs have completed the full reboot test. LUKS2/Argon2 is intentionally deferred because stock GRUB compatibility needs more integration work.
- The automatic Calamares layout erases the selected disk. The default partition choice is intentionally empty so the user must choose explicitly.
- NVIDIA's packaged open kernel module supports Turing / GTX 16 / RTX 20 and newer. Older NVIDIA hardware stays on Nouveau; no legacy AUR driver is installed.
- Plasma is Wayland-only. X11 applications run through XWayland, but there is no Plasma X11 login session.
- The LOKRO Hub contains only the Twitch-confirmed public Twitch, TikTok and Discord destinations. It has no SSO, account integration, private API or verified standalone website yet.
- Ollama support is an optional large download. AMD ROCm compatibility depends on the exact GPU; CPU fallback is always available but can be slow.
- Lokro packages are baked into the alpha ISO and do not yet have an online update repository. Arch packages continue to update from official mirrors.
- The repository contains build and VM smoke infrastructure, but real AMD/NVIDIA and multi-monitor results must be recorded by a human before publishing an image.
- The online image installs a minimal Plasma/Firefox system without internet, but selected office or gaming downloads are skipped; the offline image is the complete recovery-safe variant.
- Steam and Minecraft are proprietary. The optional bundle prepares drivers and launchers, but game assets, accounts and online authentication are never embedded in the ISO.
- Automatic install-alongside depends on the existing filesystem and free space. BitLocker, Windows Fast Startup and unusual storage controllers can prevent safe resizing; a verified backup is mandatory.
- ARM is a separate future port based on Arch Linux ARM and cannot reuse the x86_64 Archiso image.
