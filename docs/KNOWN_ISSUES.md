# KNOWN_ISSUES.md — Zentrale Fehlerliste (nur Beobachtetes)

> Stand 2026-10-15, v0.1.0-alpha.11. Vermutung ist als solche markiert.
> Build-Fehleranalyse im Detail: [`ISO_BUILD_ANALYSE_2026-10-15.md`](ISO_BUILD_ANALYSE_2026-10-15.md).
> Historische Alpha-Verläufe (5–11) sind aus `docs/RELEASE_STATUS.md` übernommen (Quelle angegeben).

## KI-001 — UEFI-Smoke ohne Linux-Eintrag (alpha.10 beobachtet, alpha.11-Fix ungeprüft)
- **Schweregrad:** P0 / blockierend für „getestetes ISO“.
- **Komponenten:** `scripts/prepare-profile.sh` (Serial-Rewrite), systemd-boot-Einträge, `scripts/smoke-boot.sh` (UEFI).
- **Repro:** `make iso-offline && make smoke-uefi` (alpha.10): Firmware erreicht systemd-boot, kein Linux-Eintrag.
- **Erwartet:** UEFI-Bootmenü mit Linux-Eintrag + `LOKRO_PLASMA_READY` via seriell.
- **Tatsächlich:** Kein Eintrag (alpha.10).
- **Ursache (nachgewiesen laut RELEASE_STATUS):** Rewrite hing Serial-Parameter an `linux`-Kernelpfad-Direktive an.
- **Fix-Versuch:** alpha.11 begrenzt Rewrite auf `APPEND`/`options` + Regressionstest in `validate.mjs`.
- **Status:** ✅ GELÖST/VERIFIZIERT am 2026-10-15 — CI-Run 38801087314 (`v0.1.0-alpha.11 Build alpha ISO`):
  `Plasma live session reached for bios` + `reached for uefi`; Size-Gate ok
  (offline 3.670.376.448 B, online 2.646.310.912 B); Prerelease publiziert. Alpha.11-Fix wirkt.
- **Nächste Diagnose:** Auf Arch beide Smokes laufen lassen, serielle Logs + `efiboot`-Einträge sichern.

## KI-002 — Flathub-Deskriptor: externer Single Point of Failure im Build
- **Schweregrad:** P0 (Build-Breaker bei Rotation/Ausfall).
- **Komponenten:** `scripts/prepare-profile.sh:38-43`, `third_party/sources.json` (SHA `3371dd25…`).
- **Repro:** ohne Netzwerk oder nach Flathub-Dateiänderung: `curl --fail …` oder `sha256sum --check` schlägt fehl → `set -euo pipefail` bricht Profilvorbereitung ab.
- **Ursache (beobachtet im Code):** Live-Download + hartcodierter Hash, kein Cache/Retry, Hash nicht aus `sources.json` gelesen.
- **Status:** offen. **Fix-Optionen:** versionierte Kopie im Repo cachen; Retry; Hash aus `sources.json` lesen + Drift-Check; als ADR entscheiden.
- **Nächste Schritte:** s. `ISO_BUILD_ANALYSE_2026-10-15.md` (B-01).

## KI-003 — Manifest-Generierung `pacman --root/--dbpath` verdächtig
- **Schweregrad:** P0 (falsche Release-Manifeste möglich).
- **Komponenten:** `scripts/checksums.sh:66-67`: `pacman --root "$installed_root" --dbpath /var/lib/pacman -Q`.
- **Beobachtung (Code, Vermutung):** absoluter `--dbpath` wird evtl. als Host-Pfad statt relativ zum Root gewertet → Manifest/Lizenz-TSV enthält Host- statt ISO-Pakete oder läuft leer.
- **Status:** Vermutung, auf Arch zu verifizieren (mit `--dbpath "$installed_root/var/lib/pacman"` bzw. nur `--root` vergleichen).
- **Nächste Schritte:** Nach erfolgreichem ISO-Build beide Varianten ausprobieren, Manifest gegen `resolved-packages-*.txt` diffen.

## KI-004 — `make validate` bricht in Fremd-Umgebungen hart ab (hier reproduziert)
- **Schweregrad:** P1 (kein Arch-Build-Blocker, aber Dev-Reibung).
- **a)** `scripts/validate_yaml.py` Exit 2, wenn `python3` da, aber PyYAML fehlt (hier 2026-10-15 reproduziert). Makefile toleriert sonst fehlende Tools mit Skip, hier nicht.
- **b)** `scripts/validate-pkgbuilds.sh:25` Exit 1: `chown -R nobody:nobody` — Gruppe existiert auf Arch, hier nicht (2026-10-15 reproduziert).
- **Fix-Optionen:** a) Makefile fängt Import-Fehler ab (Warnung+Skip); b) Gruppe dynamisch (`id -gn nobody` mit Fallback) oder Builder-User wiederverwenden.
- **Status:** offen, Arch-Verhalten unbetroffen (CI installiert `python3-yaml`; Arch kennt `nobody`).

## KI-005 — ISO-Größenpuffer fast aufgebraucht
- **Schweregrad:** P0 (Release-Gate).
- **Beobachtung (aus RELEASE_STATUS):** alpha.9 offline 3.670.376.448 B, online 2.646.310.912 B; Limit 4 GiB; alpha.7 war +39 MB drüber (Dedup-Duplikate).
- **Status:** bekannt, Dedup seit alpha.8 aktiv, aber nur ~300 MB Puffer offline.
- **Nächste Schritte:** Warnschwelle 3,8 GiB, Größen-Trend pro Build loggen, Streichkandidaten definieren.

## KI-006 — `profiledef.sh`-Rewrite ohne Verifikation
- **Schweregrad:** P0 (stiller Namens-Drift möglich).
- **Beobachtung (Code):** `sed -i` auf `iso_name/iso_version/iso_label/...` in `prepare-profile.sh:53-59` prüft Ersetzung nicht. Ändert Arch releng-Namen, heißt das ISO weiter `archlinux-*` → `smoke-boot.sh` (`lokro-os-*.iso`) findet nichts.
- **Fix:** nach sed `grep -q` auf gesetzte Werte, sonst `die`.
- **Status:** offen.

## KI-007 — GRUB-`linux`-Zeile ohne Serial-Diagnose (bewusste Lücke seit alpha.11)
- **Schweregrad:** P1 (Debug-Blindheit, kein Build-Bruch).
- **Beobachtung:** Fix begrenzt absichtlich auf `APPEND|options`; GRUB (`linux`-Direktive) bleibt ohne `console=ttyS0`.
- **Status:** Entscheidung dokumentiert, aber kein ADR; Auswirkung auf UEFI-GRUB-Pfade unbewertet.

## KI-008 — `welcome-online.conf` wird nie verkabelt
- **Schweregrad:** P1 (falsche Online-Anforderungen möglich).
- **Beobachtung (Code):** `prepare-profile.sh` tauscht nur `packages(-variant).conf` + `packagechooser-apps(-variant).conf`; `welcome-online.conf` (mit „Internet nur Warnung“-Kommentar) liegt ungenutzt neben `welcome.conf`.
- **Status:** offen — entweder kopieren oder Doku, warum identische Anforderungen ok sind.

## Umgebungs-Hinweise (keine Repo-Fehler)
- `validate_yaml.py` / `validate-pkgbuilds.sh`-Abbrüche oben sind **Umgebungs**-, keine Arch-Defekte (hier kein Arch, kein python-yaml, keine `nobody`-Gruppe).
- `node scripts/validate.mjs` bestanden; Unit-Tests 6/6; `bash -n` bestanden (2026-10-15, diese Umgebung).
- `make check-repos/packages/iso/smoke`, ShellCheck, qmllint, desktop-file-validate: hier nicht ausführbar (kein Arch / Tools fehlen) — Arch-CI-Pflicht.
