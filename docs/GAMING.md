# Gaming and Minecraft

LOKRO OS offers an optional installer choice named **Steam and Minecraft-ready**. On the offline image, its signed Arch packages and dependencies are stored in `/opt/lokro/repo`; on the online image they are fetched from the official Arch repositories. The lightweight default does not install them.

The bundle contains:

- `steam` and `steam-devices` from Arch Multilib;
- 64-bit and 32-bit Vulkan support for AMD, Intel and Nouveau, with the matching NVIDIA libraries when the NVIDIA option is selected;
- GameMode and its 32-bit library;
- Gamescope and MangoHud;
- Prism Launcher plus OpenJDK 8, 17 and 21.

Steam is proprietary software governed by Valve's subscriber agreement. Minecraft is also proprietary and is **not** redistributed. Prism Launcher is open source, but the user still needs a valid Microsoft/Minecraft account and an internet connection to download game assets. Java 8 covers older releases, Java 17 covers Minecraft 1.17–1.20.4, and Java 21 covers current releases; Prism can select the suitable runtime.

The distribution can provide drivers and runtime libraries, but it cannot guarantee that every Windows game works through Proton or that every anti-cheat vendor supports Linux. Test individual games against their publisher and Proton compatibility information.

References: [Arch Steam package](https://archlinux.org/packages/multilib/x86_64/steam/), [Arch Steam guidance](https://wiki.archlinux.org/title/Steam), [Prism Launcher Java guidance](https://prismlauncher.org/wiki/getting-started/installing-java/), [Minecraft requirements](https://www.minecraft.net/en-us/article/minecraft-java-edition-system-requirements).
