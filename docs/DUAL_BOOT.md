# Dual boot and partition safety

The installer uses Calamares' maintained partition module. Where the existing layout allows it, Calamares can shrink a partition and install LOKRO OS alongside another operating system. Manual partitioning is also available. The ISO includes KDE Partition Manager for inspection and deliberate maintenance; LOKRO does not implement a second partition engine.

Before changing a disk:

1. Back up important data and verify the backup.
2. On Windows, suspend BitLocker and disable Fast Startup before resizing its partition.
3. Keep the existing EFI System Partition; do not format it when installing alongside another UEFI system.
4. Ensure the existing system is booted in the same firmware mode used to boot the LOKRO installer.
5. Read the final Calamares summary carefully before committing changes.

The default partition choice is intentionally blank, so the user must make an explicit selection. GPT is the default for new disks, while existing partition tables remain available for legacy-BIOS compatibility. Optional LUKS1 encryption is experimental. Guaranteed dual boot, BitLocker automation and recovery of incorrectly resized filesystems are outside the alpha scope.

References: [Calamares partition options](https://calamares.io/docs/partitions/), [Arch dual boot notes](https://wiki.archlinux.org/title/Dual_boot).
