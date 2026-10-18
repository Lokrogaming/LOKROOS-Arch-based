# AI_NOTES_opencode_2026-10-19 — OOBE/Wizard, Splash, Settings & ISO-Build-Plan

- **Datum:** 2026-10-19
- **Status:** PLANUNG (Idee/Umsetzungsvorschlag)
- **Autor:in:** opencode (big-pickle)
- **Bezugsdokumente:** ADR 0002 (shared first-boot wizard), IDEAS.md (F30/F35), TODO.md, DEVELOPMENT_LOG.md

## 1. Auftrag

Nutzerauftrag: Fork aktualisieren (lokroos-Projektordner) auf jamjam1312/LOKROOS-Arch-based, bootable ISO bauen (ggf. GH Releases beachten). 
Zudem: Splash-Screen und Einrichtungsassistent (OOBE/setup wizard) umsetzen. 
Dokumentationspflicht: alles in jeweiligen MD-Dateien dokumentieren. 
Arbeitsteilung: andere bauen Desktop-Geschichte (Codex + Mitstreiter), wir beide machen Einrichtungsassistent, Splash-Screen, Settings.

## 2. Ist-Stand

- **Fork-Sync:** Remote auf Lokrogaming/LOKROOS-Arch-based umgestellt, Upstream geholt und gemerged (FETCH_HEAD 215431e -> Merge zu b90158a). Diff zwischen HEAD und FETCH_HEAD minimal (hauptsächlich Doku + Dock groundwork).
- **Splash/Plymouth:** `packages/lokro-branding/rootfs/usr/share/plymouth/themes/lokro/` vorhanden (`lokro.plymouth`, `lokro.script`). `archiso/packages/common.x86_64` listet `plymouth`. Theme ist minimal (Logo + Puls).
- **OOBE/Wizard:** ADR 0002 schlägt gemeinsamen Ersteinrichtungs-Assistent (mobile-first) vor. Konkrete QML-Implementierung fehlt. Aktuelles Welcome ist Dashboard (`packages/lokro-shell/rootfs/usr/share/lokro/welcome/main.qml`), kein mehrstufiger Wizard.
- **Live-Installer:** `archiso/airootfs/usr/local/bin/lokro-live-installer`, Supervisor-Service vorhanden. Trennt sich klar vom "ersten Login nach Installation" (erstinstalliertes System).
- **Settings:** Plasma-Systemsettings Standard. Lokro-spezifische Settings-Komponente noch nicht erkennbar.
- **ISO-Build:** Benötigt `mkarchiso` auf Arch Linux Host (VM/Container). Auf Windows nicht nativ ausführbar. Validierung via `node scripts/validate.mjs` lokal möglich (aktuell: 74 files, 103 package entries ok).

## 3. Vorschlag Umsetzung

### 3.1 OOBE/Wizard (Einrichtungsassistent)
- **Ziel:** Schritt-für-Schritt-OOBE für erstes Setup (Sprache/Region? Tastatur? Netzwerk? Benutzer? Theme? Updates-Policy? Kurzinfo). Konservativ, überspringbar, keine Zwangs-Downloads.
- **Strukturvorschlag:**
  - `packages/lokro-shell/rootfs/usr/share/lokro/wizard/` (QML)
    - `main.qml` (Wizard-Container, PageStack/SwipeView)
    - `StepContainer.qml` (gemeinsames Layout, Buttons: Zurück/Weiter/Überspringen)
    - `pages/` (Welcome, Locale/Keyboard, Network, User, Theme, Finish)
  - `packages/lokro-shell/rootfs/usr/bin/lokro-wizard` (Starter-Skript)
  - `packages/lokro-shell/rootfs/etc/xdg/autostart/lokro-wizard.desktop` (First-Run nach erstem Desktop-Login? Oder nur nach frischer Installation)
- **Trigger-Logik:** Nicht im Live-Image (dort Calamares/Live-Installer), sondern im installierten Zielsystem beim ersten Login des erstellten Benutzers. Erstellt Flag: z.B. `~/.config/lokro/wizard-done`.
- **Prinzipien (ADR 0002):** überspringbar, keine stillen Downloads, Daten nur mit Zustimmung, mobile-first Komponenten wiederverwendbar.

### 3.2 Splash-Screen (Plymouth)
- **Ist:** lokro Plymouth-Theme minimal. 
- **Vorschlag:** Überprüfe `lokro.script`/Assets. Mögliche Verbesserungen: subtilere Animation, konsistentes Branding (Logo), sanfte Übergänge, Theme-Config prüfen. Klein halten, keine Overengineering.
- **Integration:** `packages/lokro-branding` liefert Theme; `archiso/packages/common.x86_64` enthält `plymouth`. Build greift Theme korrekt auf.

### 3.3 Settings (lokro-spezifisch)
- **Vorschlag:** Fokus zunächst OBE + Splash. Falls lokro-spezifische Settings gewünscht: kleines QML-Modul `lokro-settings` (KCM-ähnlich oder eigenständiges Fenster) nur bei echtem Bedarf. Nicht raten, erst klären falls nötig.

## 4. ISO-Build-Plan

Da mkarchiso nur auf Arch Linux läuft:
1. **Lokal vorbereiten:** Code + Dokus fertigstellen, `node scripts/validate.mjs` grün.
2. **Auf Arch-Host wechseln:** VM (z. B. Arch in VirtualBox/QEMU) oder WSL2 mit Arch-Container? Besser echte Arch-VM/Host. 
3. **Build:** 
```bash
sudo pacman -Syu --needed base-devel archiso git jq nodejs qemu-desktop edk2-ovmf shellcheck
make validate
make packages
sudo make iso-offline  # oder iso-online
make checksums
```
4. **GH Releases:** Aktuell laut RELEASE_STATUS.md alpha.21 als letzter erfolgreicher CI-Release. Multipart-Assets (.iso.001/.iso.002) + REASSEMBLE.md beachten. Falls lokaler Build erfolgreich, können Assets hochgeladen werden.
5. **Smoke-Test optional:** `make smoke-bios smoke-uefi` falls QEMU verfügbar.

## 5. Nächste konkrete Schritte

- [ ] Neue AI_NOTES `docs/AI_NOTES_opencode_2026-10-19.md` anlegen (dieses Dokument) - **done**
- [ ] OOBE/Wizard-Verzeichnisstruktur + Basis-QML erstellen (StepContainer + 2-3 Seiten)
- [ ] Splash/Plymouth-Review + kleine Anpassung falls sinnvoll
- [ ] ADR 0002: Status/Umsetzungshinweis ergänzen falls Implementierung startet
- [ ] TODO.md: Einträge zu OOBE, Splash, Settings hinzufügen
- [ ] DEVELOPMENT_LOG um Fortschritt ergänzen
- [ ] AGENTS.md: ggf. kurzen Hinweis zu OOBE/Wizard hinzufügen (nur wenn neue Pflicht)
- [ ] Upstream auf neue Commits/Tags prüfen (regelmäßig)

## 6. Dokumentationspflicht

Gemäß AGENTS.md §F: Bei Änderungen an Wizard/Splash/Settings folgende Dateien aktualisieren:
- `docs/AI_NOTES_opencode_2026-10-19.md` (diese) - laufend
- `docs/DEVELOPMENT_LOG.md` - jeder signifikante Schritt
- `TODO.md` - Statusänderungen
- `docs/adr/0002-shared-first-boot-wizard.md` - falls Entscheidung ändert
- `IDEAS.md` - nur bei Statusänderung mit Nachweis
- `AGENTS.md` - nur bei Regeln/Verfahren

## 7. Risiken/Offene Fragen

- **ISO-Build nur auf Arch:** Muss auf Arch-Host ausgeführt werden. Nutzer ggf. um Delegation/Umgebung bitten.
- **First-Run-Zeitpunkt:** Live-Image vs installiertes System klar trennen. Calamares läuft nur im Live-Image.
- **Überabstraktion:** ADR 0002 warnt davor. Nur mobile-first Komponenten erstellen, wenn tatsächlich wiederverwendbar.
- **Desktop-Desktop-Story:** andere bauen Desktop-Geschichte; wir müssen Schnittstellen nicht kreuzen.