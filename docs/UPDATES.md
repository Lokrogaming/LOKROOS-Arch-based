# Update design

LOKRO OS uses official Arch repositories for the base system and the pinned GitHub repository `jamjam1312/LOKROOS-Arch-based` for LOKRO-specific release metadata and package archives.

## Safe default

`lokro-update.timer` starts three minutes after boot and then every five hours with a randomized delay. It runs with low CPU and I/O priority. The default `download` policy:

1. fetches and strictly validates `LOKRO_UPDATE_CHANNEL.json` over HTTPS;
2. uses `checkupdates` from `pacman-contrib`, avoiding an unsupported partial upgrade;
3. downloads official Arch updates into Pacman's cache;
4. downloads a versioned LOKRO package archive only when the channel advertises a newer LOKRO version, only from this repository's GitHub Release, and verifies its SHA-256 file;
5. never installs a package without a local administrator confirmation.

An unreachable server, malformed JSON, missing release or checksum mismatch is recorded as status and leaves the installed system unchanged. Remote metadata cannot turn on unattended installation. Local administrators may change `/etc/lokro/update.conf`, but `install` mode is intentionally not the default.

## Applying updates

The **LOKRO OS Updates** launcher uses Polkit and runs `/usr/bin/lokro-update apply`. Before Pacman changes the system, it records explicitly installed packages and archives `/etc`, `/boot` and Pacman's local database in `/var/lib/lokro-update/backups/`. If the backup fails or free space is below the configured threshold, installation is refused. Pacman always performs a complete `-Syu`; partial upgrades are not used. The exact cached LOKRO release named by the validated channel is checksum-verified again immediately before extraction, and a failed local package installation is reported instead of being labelled successful.

The backup is a recovery aid, not a transactional filesystem snapshot. User home directories are not modified or backed up by the updater. Users remain responsible for separate backups of personal files.

## Running kernel

Installing a new kernel package does not replace the kernel already running in memory. Two Pacman hooks retain the modules belonging to that running kernel, which prevents the common failure where newly connected USB, storage or network hardware cannot load a module before reboot. The new kernel becomes active only after reboot; true general-purpose live kernel replacement is not claimed.

## Trust boundary

Official Arch packages keep Pacman's normal signature verification. LOKRO package archives are restricted to HTTPS assets of the pinned GitHub repository and checked against the release checksum. Public-key signing of LOKRO's own package database is still required before a stable release; therefore unattended LOKRO package installation remains disabled in the alpha.
