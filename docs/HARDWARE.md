# Hardware support

LOKRO OS uses the unmodified Arch `linux` kernel, udev and current `linux-firmware`. USB HID, USB storage, SATA/NVMe, common Ethernet and common Wi-Fi drivers therefore come from the upstream kernel rather than LOKRO-specific code.

The image explicitly includes NetworkManager, `iw`, IWD, the wireless regulatory database, BlueZ, ModemManager, USB/PCI inspection tools, UDisks, UPower, Thunderbolt support, firmware update support, common sound firmware and FAT/exFAT/NTFS utilities. Plasma supplies graphical controls for Wi-Fi, Ethernet, Bluetooth, displays, mouse, keyboard, power and shortcuts. Bluetooth and NetworkManager are enabled after installation.

No finite ISO can contain a working driver for every device. Hardware that needs a vendor-only out-of-tree module, very new firmware released after the ISO, or Broadcom/other licensing-restricted firmware may need a wired connection and manual setup. Real AMD, Intel, NVIDIA, Wi-Fi, Bluetooth, audio, suspend and multi-monitor tests remain release gates.

References: [Arch USB storage](https://wiki.archlinux.org/title/USB_storage_devices), [Arch Bluetooth](https://wiki.archlinux.org/title/Bluetooth), [NetworkManager package files](https://archlinux.org/packages/extra/x86_64/networkmanager/files/).
