#!/usr/bin/env node
// SPDX-License-Identifier: GPL-3.0-or-later
import fs from "node:fs";
import path from "node:path";
import process from "node:process";

const root = path.resolve(path.dirname(new URL(import.meta.url).pathname.replace(/^\/(.:)/, "$1")), "..");
const failures = [];
const required = [
  "VERSION", "Makefile", "CONTRIBUTORS.md", "desktop/README.md", "server/README.md",
  "LOKRO_UPDATE_CHANNEL.json", "schemas/update-channel.schema.json", "docs/UPDATES.md",
  "docs/RELEASE_STATUS.md", "archiso/packages/common.x86_64",
  "archiso/packages/offline.x86_64", "archiso/packages/online.x86_64",
  "archiso/airootfs/etc/plymouth/plymouthd.conf",
  "vendor/ckbcomp/PKGBUILD",
  "packages/lokro-branding/PKGBUILD", "packages/lokro-shell/PKGBUILD",
  "packages/lokro-installer-config/PKGBUILD", "packages/lokro-ai-setup/PKGBUILD",
  "packages/lokro-shell/rootfs/usr/share/plasma/wallpapers/org.lokro.slashes/metadata.json",
  "packages/lokro-shell/rootfs/usr/share/plasma/plasmoids/org.lokro.hub/metadata.json",
  "packages/lokro-shell/rootfs/usr/share/lokro/services.json",
  "packages/lokro-shell/rootfs/usr/share/lokro/services.schema.json",
  "packages/lokro-shell/rootfs/usr/share/lokro/welcome/main.qml",
  "packages/lokro-shell/rootfs/usr/share/lokro/welcome/WelcomeCard.qml",
  "packages/lokro-shell/rootfs/usr/bin/lokro-welcome",
  "packages/lokro-shell/rootfs/usr/bin/lokro-action",
  "packages/lokro-shell/rootfs/usr/bin/lokro-update",
  "packages/lokro-shell/rootfs/usr/bin/lokro-update-gui",
  "packages/lokro-shell/rootfs/usr/lib/systemd/system/lokro-update.timer",
  "packages/lokro-shell/rootfs/usr/lib/lokro-update/keep-running-kernel",
  "packages/lokro-installer-config/rootfs/etc/calamares/modules/packagechooser-gaming.conf",
  "packages/lokro-installer-config/rootfs/etc/calamares/modules/packagechooser-apps-offline.conf",
  "packages/lokro-installer-config/rootfs/etc/calamares/modules/packagechooser-apps-online.conf",
  "archiso/airootfs/usr/local/sbin/lokro-smoke-ready",
  "scripts/smoke-boot.sh",
  "scripts/validate-pkgbuilds.sh",
  "third_party/sources.json", "docs/AI_DISCLOSURE.md"
];
for (const rel of required) if (!fs.existsSync(path.join(root, rel))) failures.push(`missing: ${rel}`);

function walk(dir) {
  return fs.readdirSync(dir, {withFileTypes: true}).flatMap(e => {
    const p = path.join(dir, e.name);
    return e.isDirectory() ? walk(p) : [p];
  });
}

for (const file of walk(root)) {
  const skippedDirectories = [".git", "build", "out", "outputs", "work"];
  if (skippedDirectories.some(directory => file.includes(`${path.sep}${directory}${path.sep}`))) continue;
  const rel = path.relative(root, file).replaceAll("\\", "/");
  if (file.endsWith(".json")) {
    try { JSON.parse(fs.readFileSync(file, "utf8")); } catch (e) { failures.push(`${rel}: invalid JSON (${e.message})`); }
  }
  if (/\.(sh|py)$/.test(file) || rel.includes("/usr/bin/") || rel.includes("/usr/local/sbin/")) {
    const text = fs.readFileSync(file, "utf8");
    if (!text.startsWith("#!")) failures.push(`${rel}: missing shebang`);
  }
  const text = fs.readFileSync(file, "utf8");
  if (/curl[^\n|]*\|\s*(sh|bash)/.test(text)) failures.push(`${rel}: forbidden curl-pipe-shell pattern`);
}

const packageFiles = ["common", "offline", "online"].map(variant => `archiso/packages/${variant}.x86_64`);
const packageSets = Object.fromEntries(packageFiles.map(file => [file, fs.readFileSync(path.join(root, file), "utf8")
  .split(/\r?\n/).map(x => x.trim()).filter(x => x && !x.startsWith("#"))]));
const packageLines = Object.values(packageSets).flat();
for (const forbidden of ["yay", "paru", "pamac-aur"]) if (packageLines.includes(forbidden)) failures.push(`forbidden runtime AUR helper: ${forbidden}`);
for (const [file, packages] of Object.entries(packageSets)) {
  const dupes = packages.filter((x, i) => packages.indexOf(x) !== i);
  if (dupes.length) failures.push(`${file}: duplicate package names: ${[...new Set(dupes)].join(", ")}`);
}
for (const localPackage of ["ckbcomp", "calamares-lokro", "lokro-branding", "lokro-shell", "lokro-installer-config", "lokro-ai-setup"]) {
  if (!packageSets["archiso/packages/common.x86_64"].includes(localPackage)) failures.push(`common ISO package list is missing ${localPackage}`);
}
for (const requiredOffline of ["libreoffice-fresh", "libreoffice-fresh-de"]) {
  if (!packageSets["archiso/packages/offline.x86_64"].includes(requiredOffline)) failures.push(`offline ISO package list is missing ${requiredOffline}`);
}
for (const requiredCommon of [
  "firefox", "firefox-i18n-de", "networkmanager", "iwd", "wireless-regdb",
  "bluez", "bluez-utils", "usbutils", "linux-firmware", "sof-firmware",
  "mesa", "vulkan-radeon", "vulkan-intel", "vulkan-nouveau",
  "lib32-mesa", "lib32-vulkan-radeon", "lib32-vulkan-intel", "lib32-vulkan-nouveau",
  "pipewire", "wireplumber", "grub", "efibootmgr", "cryptsetup", "sddm",
  "pacman-contrib", "partitionmanager", "flatpak", "discover", "systemsettings", "powerdevil"
]) {
  if (!packageSets["archiso/packages/common.x86_64"].includes(requiredCommon)) failures.push(`common ISO package list is missing ${requiredCommon}`);
}

const gamingChooser = fs.readFileSync(path.join(root, "packages/lokro-installer-config/rootfs/etc/calamares/modules/packagechooser-gaming.conf"), "utf8");
for (const gamingPackage of ["steam", "prismlauncher", "jre8-openjdk", "jre17-openjdk", "jre21-openjdk", "gamemode", "gamescope", "mangohud"]) {
  if (!new RegExp(`(^|\\s)-?\\s*${gamingPackage.replace(/[.*+?^${}()|[\\]\\]/g, "\\$&")}($|\\s)`, "m").test(gamingChooser)) failures.push(`gaming chooser is missing ${gamingPackage}`);
}

const version = fs.readFileSync(path.join(root, "VERSION"), "utf8").trim();
if (!/^\d+\.\d+\.\d+-alpha\.\d+$/.test(version)) failures.push(`VERSION is not an alpha SemVer: ${version}`);

const prepareProfile = fs.readFileSync(path.join(root, "scripts/prepare-profile.sh"), "utf8");
if (!prepareProfile.includes("ln -sfn /etc/systemd/system/lokro-live-user.service")) {
  failures.push("live-user enablement must point to the unit stored under /etc/systemd/system");
}
const mergeService = fs.readFileSync(path.join(root, "packages/lokro-shell/rootfs/usr/lib/systemd/system/lokro-services-merge.service"), "utf8");
if (!/\[Install\][\s\S]*WantedBy=multi-user\.target/.test(mergeService)) {
  failures.push("lokro-services-merge.service must be enableable by Calamares");
}

const rootUpdateChannelText = fs.readFileSync(path.join(root, "LOKRO_UPDATE_CHANNEL.json"), "utf8");
const packagedUpdateChannelText = fs.readFileSync(path.join(root, "packages/lokro-shell/rootfs/usr/share/lokro/update-channel.json"), "utf8");
if (rootUpdateChannelText !== packagedUpdateChannelText) failures.push("packaged update channel differs from root LOKRO_UPDATE_CHANNEL.json");
const updateChannel = JSON.parse(rootUpdateChannelText);
if (updateChannel.version !== version) failures.push("update channel version differs from VERSION");
if (updateChannel.repository !== "jamjam1312/LOKROS-Arch-based") failures.push("update channel repository is not pinned");
if (updateChannel.architecture !== "x86_64") failures.push("update channel architecture must be x86_64");
if (updateChannel.automaticPolicy?.installWithoutLocalConfirmation !== false) failures.push("remote policy must not permit unattended installation");

const services = JSON.parse(fs.readFileSync(path.join(root, "packages/lokro-shell/rootfs/usr/share/lokro/services.json"), "utf8"));
if (!Array.isArray(services.services)) failures.push("services.json must contain a services array");
for (const svc of services.services ?? []) for (const key of ["id", "name", "url", "icon"]) if (typeof svc[key] !== "string") failures.push(`service entry missing string ${key}`);

const aiReleases = JSON.parse(fs.readFileSync(path.join(root, "packages/lokro-ai-setup/rootfs/usr/share/lokro-ai/releases.json"), "utf8"));
for (const artifact of [aiReleases.ollama?.base, aiReleases.ollama?.rocm]) {
  if (!artifact?.url?.startsWith("https://")) failures.push("AI artifact URL must use HTTPS");
  if (!/^[a-f0-9]{64}$/.test(artifact?.sha256 ?? "")) failures.push("AI artifact must have a lowercase SHA-256 digest");
}

if (failures.length) {
  console.error(failures.map(x => `FAIL ${x}`).join("\n"));
  process.exit(1);
}
console.log(`Validated ${required.length} required files, ${packageLines.length} package entries across three profiles, and JSON/config invariants.`);
