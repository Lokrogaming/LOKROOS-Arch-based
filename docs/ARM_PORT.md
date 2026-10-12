# Experimental ARM port plan

The v0.1 images remain x86_64. Arch Linux's official distribution and Archiso target x86_64, while ARM systems use the separate Arch Linux ARM repositories, device kernels and boot firmware. A single universal ISO is therefore not realistic.

The first sensible ARM target is generic AArch64 with UEFI, followed by a separately tested Raspberry Pi 4/5 image. Shared Lokro packages should remain architecture-independent wherever possible; GPU drivers, bootloader, kernel, firmware and image generation must be separate. Work may start only after the x86_64 installer boots reliably, and no ARM image should be advertised without a named board and real-hardware test result.
