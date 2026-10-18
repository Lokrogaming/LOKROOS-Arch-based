# DEVELOPMENT_LOG.md — Technisches Entwicklungstagebuch

> Chronologisch anhängen, nie still überschreiben. Keine Pauschalen, keine erfundenen Historien.
> Quellen (Git-Log, Dateien, Befehle) angeben; Unbekanntes bleibt unbekannt.

## 2026-10-15 — Bestandsaufnahme + Doku-Fundament (diese Sitzung)

- **Bereich:** Repo-weite Analyse + Dokumentationsstruktur (Master-Prompt Phase 1–2).
- **Ausgangszustand:** Kein `AGENTS.md`/`IDEAS.md`/`TODO.md`/`IMPORTANT.md`, kein `docs/adr/`; `docs/ARCHITECTURE.md` kurz (41 Zeilen);
  kein `DEVELOPMENT_LOG.md`/`KNOWN_ISSUES.md`; Version `0.1.0-alpha.11`, Branch `main`, Arbeitsbaum laut `git status` sauber (soweit einsehbar).
  Git-Historie (Quelle: `git log --oneline -15`): u. a. `5eb1419 Fix UEFI live boot entry for alpha.11 (#10)`,
  `80d7e30 Start live-session helpers through Bash for alpha.10`, `36a3d5a Use portable Pacman queries for alpha.9`.
  Details einzelner Commits wurden nicht geöffnet (nur Betreffzeilen als Quelle).
- **Durchgeführte Änderungen (neu erstellt):**
  - `AGENTS.md` (Regeln A–G + Arbeitsablauf + KI-Gedanken-Regel ab 2026-10-15).
  - `IDEAS.md` (Roadmap F01–F29 + KI-Konzept Kap. 9 + Master-Prompt-Volltext als Anhang).
  - `TODO.md` (P0–P3 mit Akzeptanzkriterien).
  - `docs/KNOWN_ISSUES.md` (KI-001–KI-008).
  - `docs/ISO_BUILD_ANALYSE_2026-10-15.md` (B-01–B-10 mit Dringlichkeit + Fixes).
  - Dieses Log (`docs/DEVELOPMENT_LOG.md`).
- **Noch zu ändern (Folgeschritte dieser Sitzung):** `docs/ARCHITECTURE.md` erweitern, `AI_INFO.md` um KI-Regel ergänzen,
  Links/Code-Abgleich prüfen, Abschlussbericht schreiben.
- **Ausgeführte Befehle (sicher, nicht-destruktiv):** `git status/branch/log`, `node scripts/validate.mjs`,
  `python3 -m unittest discover -s tests -v`, `bash -n …`, `python3 scripts/validate_yaml.py`, `bash scripts/validate-pkgbuilds.sh`,
  Datei-Lesungen (Skripte, Manifeste, Calamares-Module, Workflows).
- **Testergebnisse:** `validate.mjs` ✅ (55 Dateien, 102 Pakete); Unit-Tests ✅ 6/6; `bash -n` ✅;
  `validate_yaml.py` ⚠️ Exit 2 (PyYAML fehlt — Umgebung); `validate-pkgbuilds.sh` ⚠️ Exit 1 (`nobody:nobody` fehlt — Umgebung);
  ShellCheck/qmllint/desktop-validate hier nicht installiert; `check-repos/packages/iso/smoke` nur auf Arch möglich.
- **Aufgetretene Fehler:** keine Repo-Änderung vorgenommen (reine Doku-Sitzung); Umgebungs-Abbrüche s. oben, als solche in KNOWN_ISSUES (KI-004) dokumentiert.
- **Auswirkungen:** keine Laufzeitänderung; neue Doku referenziert Code-Stand alpha.11.
- **Nächste Schritte:** ARCHITECTURE/AI_INFO fertigstellen → Verifizierung (Links, Status vs. Code) → Abschlussbericht.

## 2026-10-15 — Verifizierung + Abschluss (gleiche Sitzung)

- **Bereich:** Phase 3–4 des Master-Prompts.
- **Nachgetragene Änderungen:** `docs/ARCHITECTURE.md` (Interaktion/Schnittstellen/Live-vs-installiert/ADR-Kandidaten, Englisch),
  `AI_INFO.md` (KI-Arbeitsregel seit 2026-10-15: eigene MD pro KI + Verweis auf `AGENTS.md`/`IDEAS.md`-Anhang).
- **Verifizierung:** `validate.mjs` ✅, Unit-Tests 6/6 ✅, `bash -n` ✅; alle `[…](…)`-MD-Links in den 8 Dateien lösen auf (✅);
  Code-Stellen gegengeprüft: Flathub-Block (3 Treffer), dbpath (2), `nobody:nobody` (1), `welcome-online` in
  `prepare-profile.sh` = 0 Treffer (bestätigt KI-008). Statuswerte in `IDEAS.md`/`RELEASE_STATUS.md` stimmen überein
  (BIOS TESTED, UEFI BLOCKED, KI nur IDEA). Keine Code-Änderung, keine riskanten Befehle.
- **Arbeitsbaum:** geändert `AI_INFO.md`, `docs/ARCHITECTURE.md`; neu `AGENTS.md`, `IDEAS.md`, `TODO.md`,
  `docs/KNOWN_ISSUES.md`, `docs/ISO_BUILD_ANALYSE_2026-10-15.md`, `docs/DEVELOPMENT_LOG.md` (diese Datei).
- **Offen:** alles unter `TODO.md` (P0 zuerst); Arch-Läufe (`check-repos/packages/iso/smoke`, ShellCheck/QML/Desktop-Lint).

## 2026-10-15 — OpenClaw-Konzept dokumentiert (gleiche Sitzung, kein Commit/Push)

- **Bereich:** `IDEAS.md` Kap. 9.9 (neu), `TODO.md`, dieses Log. Kein Code, keine Config-Änderung.
- **Ausgangszustand:** Kap. 9 beschrieb nur generischen lokalen Chat-Assistenten (IDEA).
- **Änderungen:** Neues Feature F25b (OpenClaw-artige Systemsteuerung, IDEA) mit Unterabschnitten: Ziel/Leitplanken
  (Allowlist, Bestätigungspflicht, Audit; „unzensiert" ≠ Garantie), Benchmark-bei-Ersteinrichtung (nicht bei jedem Boot,
  Modelle nie im ISO, Download nur nach Zustimmung aus gepinnter Quelle), Claw-Hook als Werkzeug-Gateway
  (Policy-Prüfung, Risikoklassen, keine direkten Root-Aktionen aus dem Modell), Berechtigungsmatrix
  (Apps/Dateien/Aktionen, Standard restriktiv, Audit-Ansicht), BYOK (Schlüssel im Secret Service, nie in Logs),
  Abhängigkeiten (Backend, Registry, Benchmark, Gateway, UI, Plattenplatz), Schritte + Akzeptanzkriterien.
  `TODO.md` um F25b-Doku-Aufgabe ergänzt.
- **Grund:** Wunsch des Projektverantwortlichen (Chat 2026-10-15), Konzept vor jeder Implementierung festzuhalten.
- **Tests:** keine (Doku). `validate.mjs`-relevante Muster vermieden (keine Shell-Pipelines im Text).
- **Offen:** ADR Bedrohungsmodell/Policy-Format als nächster Doku-Schritt, erst nach Build-Stabilisierung (P0).

## 2026-10-15 — CI-Erfolg: BIOS+UEFI-Smoke grün, v0.1.0-alpha.11 publiziert

- **Quelle:** `gh run view 38801087314` (origin-Repo, Codex-Build, angestoßen per Push ca. 20:20 UTC; Job `build` ✅ in 23m57s).
- **Nachweise aus dem Log:** `Plasma live session reached for bios` (20:41:43Z) + `reached for uefi` (20:42:15Z);
  Size-Gate: offline 3.670.376.448 B, online 2.646.310.912 B (beide < 4 GiB); Prerelease `v0.1.0-alpha.11` publiziert
  (u. a. je 2 ISO-Teile pro Variante, Manifeste, Lizenzen, Provenienz). Nebenbei: qmllint meldet nur Warnungen
  (`Unqualified access` im Hub-Plasmoid, nicht fatal); Arch zieht inzwischen Plasma 6.8.0.
- **Doku-Folgen (Fork-Branch):** KI-001 → gelöst/verifiziert; `IDEAS.md` F04 BLOCKED → TESTED; `TODO.md` P0-UEFI abgehakt.
  Verbleibend für „getestetes ISO" laut `RELEASE_STATUS.md`: VM-Installation + Hardware-Matrix (Menschenarbeit).
- **Tests:** keine lokalen (nur Log-Auswertung per `gh`). Kein Eingriff in Codex' Build.

## 2026-10-15 — Codex-Branches per `gh` geprüft (kein Commit/Push)

- **Bereich:** Branch-Hygiene. Befehle (lesend): `gh auth status` (ok, Account Lokrogaming),
  `gh pr list --state all` (10 PRs, alle MERGED, keine offenen), `git diff main origin/<branch> --stat` je Branch.
- **Ergebnis:** Alle 10 `codex/*`-Branches sind stale Reste squash-gemergter PRs (alpha.2–alpha.11); kein Branch enthält
  Inhalte, die nicht in `main` sind (`codex/uefi-entry-alpha11` ist byte-identisch mit `main`; übrige Diffs sind nur
  fehlende Folge-Commits, z. B. `server/README.md` Versionsstring alpha.2→alpha.11 längst in `main`).
- **Änderungen:** `TODO.md` um Aufräum-Aufgabe ergänzt (Löschen erst nach laufendem Codex-Build). Remote-Branches wurden
  **nicht** gelöscht (laufender Build soll nicht gestört werden). Keine Auswirkung auf `IDEAS.md`-Statuswerte.

## 2026-10-15 — Fork + eigene Branch gesichert (Fortschritt saved)

- **Bereich:** Remote-Setup. Befehle: `gh repo fork jamjam1312/LOKROOS-Arch-based --clone=false` →
  `https://github.com/Lokrogaming/LOKROOS-Arch-based`; `git remote add fork …`; Commit `26a9fe7`
  (8 Doku-Dateien, 759 Zeilen, Autor Lokrogamer via noreply); `git push -u fork docs/session-2026-10-15`.
- **Ausgangszustand:** Direkt-Push nach `origin` scheiterte mit 403 (nur Lesezugriff für Lokrogaming).
- **Neuer Workflow (verbindlich ab jetzt):** Gearbeitet wird auf Branch `docs/session-2026-10-15` mit Upstream `fork`;
  `origin` (Freundes-Repo, Codex-Build) wird weder beschrieben noch angetoucht. Dieses Tagebuch wird strikt weitergeführt,
  damit Codex später jede Änderung zurückverfolgen kann.
- **Tests:** keine (Remote-/Git-Operationen). Branch-Tracking verifiziert (`git push` geht künftig an `fork`).

## 2026-10-15 — GitHub-Pages-Website auf dem Fork (Branch `gh-pages`)

- **Bereich:** Website (neu, nur Fork). Umsetzung per separatem Worktree (`/tmp/opencode/lokro-site`, Orphan-Branch),
  Haupt-Arbeitsbaum blieb auf `docs/session-2026-10-15` und wurde nicht angetoucht.
- **Inhalt:** `index.html` (258 Zeilen, deutsch, responsiv): Tailwind-CDN + Alpine.js (mobiles Menü, Varianten-Tabs,
  FAQ-Akkordeon, Copy-Button), Glass-Design im OS-Farbkleid (`#111019`, `#f5f4fb`), Hero, Desktop-Mock, 9 Feature-Karten,
  Offline/Online-Vergleich, Download-Sektion mit Direktlinks auf die Release-Teile + `cat`-Reassemble-Snippet,
  ehrlicher alpha.11-Status, FAQ, Footer. Hinweisbox für künftigen Voll-ISO/ZIP-Download über `docs/` ist vorbereitet.
  Anmerkung: „hyperux“ wurde als HyperUI-artige Komponenten (handgebaut, keine extra Dependency) interpretiert.
- **Deploy:** Commit `2afffe5` → `git push -u fork gh-pages`; Pages-Quelle per API auf `gh-pages`/`/` bestätigt
  (Status `building`, URL `http://lokro.dev/LOKROOS-Arch-based/` — Custom-Domain des Accounts).
- **Offen:** Voll-ISO/ZIP unter `docs/` ablegen + hier verlinken (eigene Aufgabe, Datei >2 GiB beachten);
  visuelle Abnahme im Browser durch Menschen.

## 2026-10-16 — Upstream alpha.13/14 gemergt + Stil-Regel verfeinert (Fork)

- **Bereich:** Merge `origin/main` (`d65fffa`: Store-Integration #14, Store-Backend #15, Release-Status #16, CONTRIBUTORS;
  Tags alpha.13/alpha.14) in Docs-Branch; Doku-Folgen; kein `origin`-Eingriff.
- **Konflikt:** Nur `AGENTS.md` (add/add: unsere Vollversion vs. Upstream-Kurzfassung). Gelöst: unsere Struktur behalten,
  Fakten aktualisiert (5 Pakete, UEFI TESTED, alpha.14, Tippfehler behoben), Upstream-Regeln integriert
  (Store-Katalog-Regel als Nr. 14). Kein Inhalt verloren.
- **Doku-Folgen:** `IDEAS.md` F31 IDEA → PARTIAL (`lokro-store`-Paket: gepinnter Upstream-Tarball, Katalog+Schema,
  PySide6-GUI); F34 + `AGENTS.md` Designprinzip um **Chamfer-mit-Maß** ergänzt (Chamfer nur wo sinnvoll, Standard
  Rundung×Glass, Widgets per Customize-Dialog umschaltbar, KI-Theming-Hooks geplant); Header auf alpha.14.
- **Tests:** `validate.mjs` beim Commit (Pflicht). Kein Code, keine Builds.

## 2026-10-16 — TODO-Rework übernommen, alpha.12 gemergt, Ideen ausgeplant

- **Bereich:** `TODO.md`, `IDEAS.md`, `AGENTS.md`, Branch-Pflege (alles Fork, kein `origin`-Eingriff).
- **Ausgangszustand:** Eigene `Versionen`-TODOs (Mobile, Store, APK) per PR #1 im Fork; upstream-`main` inzwischen auf
  alpha.12 (`90d024b`: Design-Packs #12 + Release-Record #13, Tag `v0.1.0-alpha.12`).
- **Änderungen:** 1) Lokal auf Fork-Stand fast-forwardet (PR #1 übernommen). 2) `origin/main` in Docs-Branch gemergt
  (konfliktfrei). 3) Versionsheader AGENTS/IDEAS/TODO → alpha.12. 4) `IDEAS.md`: F30 (Mobile), F31 (Store),
  F32 (APK) als volle Steckbriefe — inkl. ehrlicher Blocker (Play braucht Google-Lizenz; „fast alle APKs" ohne Nachweis
  unrealistisch, Waydroid-Pfad); F33 Design Packs als IMPLEMENTED; F25b-Planung vervollständigt (9.9.8 Policy-Format-Draft,
  9.9.9 Benchmark-Schwellen, 9.9.10 Registry-Schema, 9.9.11 Bedrohungsmodell-Kurzfassung). 5) Docs-Branch in Fork-`main`
  gemergt (Fast-Forward) — TODO-Rework steht damit auf allen aktiven Fork-Branches.
- **Tests:** `node scripts/validate.mjs` ✅ (63 Dateien nach alpha.12-Anforderungen). Kein Code, keine Builds.

## 2026-10-16 — Mobile-Vorgabe: keine lokale KI, nur BYOK

- **Bereich:** `IDEAS.md` (F30 + 9.9.5). Kein Code.
- **Vorgabe des Projektverantwortlichen:** Mobile bekommt keine integrierte KI (Prozessor/RAM/Storage zu klein für ein
  fähiges Modell); KI mobil ausschließlich per BYOK (z. B. ChatGPT-/Claude-/Anthropic-Schlüssel), sonst läuft das System ohne KI.
- **Tests:** keine (Doku).

## 2026-10-16 — PR #17: Website als PR ans Original (PR #11 weiter aktuell)

- **Befund:** PR #11 (Docs) ist aktuell (Head `2076c43`, MERGEABLE, CI wartet weiter auf Freigabe).
  Direkt-PR aus Orphan-Branch `gh-pages` scheiterte (keine gemeinsame Historie) → neue Branch `website-preview`
  auf `origin/main` (`d65fffa`) mit nur `index.html` (Rebase `--onto`), PR #17 ans Original eröffnet.

## 2026-10-16 — Mobile-Brainstorm: Input, eigenes OS, Konnektivität, APK/Stores

- **Bereich:** `IDEAS.md` F30-Vertiefung (alles IDEA, kein Code). Anstoß: Wunsch des Projektverantwortlichen.
- **Ergebnis:** Shell zuerst entscheiden (Plasma-Mobile-Kandidat vs. Phosh — ADR); Maliit + LOKRO-Layout, Gesten-Ebene,
  `feedbackd`, Lockscreen mit Notruf. Eigenes `mobile`-Profil ohne Gaming/NVIDIA/Office, dafür Waydroid + Stores + Dialer/SMS;
  Flash-Images + Einrichtungs-Assistent statt Calamares. Konnektivität: Basis vorhanden, SIM/Anruf/SMS/Hotspot fehlen,
  VoLTE offen. Stores: eigener + Aurora + F-Droid; Android-Image-Download nur nach Zustimmung.
  Hardware: 1–2 Referenzgeräte, Mainline-vs-Halium als ADR.
- **Tests:** `node scripts/validate.mjs` nach dem Edit folgt beim Commit (Pflicht vor Push).

## 2026-10-16 — ADR-Entwürfe 0001/0002 eingetragen (Vorschläge, kein Beschluss)

- **Bereich:** `docs/adr/` (neu), Verweise in `IDEAS.md` (F30) + `docs/ARCHITECTURE.md`, dieses Log.
- **Inhalt:** 0001 Mobile-Shell (Plasma Mobile Leitkandidat, Phosh nur bei Showstopper mit Ausstiegskriterien);
  0002 gemeinsamer Ersteinrichtungs-Assistent (mobile-first, später Desktop-Welcome, Calamares bleibt Installer).
- **Tests:** `validate.mjs` beim Commit (Pflicht).

## 2026-10-16 — Branding-Beschluss: lokro.dev-Stil verbindlich (F34, PLANNED)

- **Bereich:** `IDEAS.md` (F34 + Kap. 10.1), `AGENTS.md` (Designprinzip), dieses Log. Kein Code.
- **Quellen (gelesen):** `https://lokro.dev/branding` (→ `/de/branding.html`: Tokens, Chamfer-Klassen, Fonts, Logo-Regeln),
  Repo `Lokrogaming/lokrogaming.github.io`, `assets/site.css` (Chamfer = Clip-Pfad 18/10/28 px, Card-Hover-Lift + Glow).
- **Beschluss:** Chamfer-Cards etc. werden von lokro.dev übernommen (Mint `#7fe3b4`, Space Grotesk/Inter/JetBrains Mono).
  Ehrlich vermerkt: OS nutzt heute noch eigene Werte (rund, Zink, kein Mint) — Migration ist offene Arbeit.
- **Tests:** `validate.mjs` beim Commit (Pflicht).

## 2026-10-16 — PR-Lage ans Original-Repo geklärt (kein neuer PR nötig)

- **Befund per `gh`:** Upstream-PR #11 (`Lokrogaming:docs/session-2026-10-15` → `main`) existiert, ist aktuell
  (Head `05e8230`, alle neuen Commits enthalten) und MERGEABLE. Alle Codex-Branches sind über PRs #1–#10, #12, #13
  gemergt; Fork-PR #1 gemergt; `gh-pages` ist Website-only (kein PR nach `main`, würde Repo-Root verunreinigen).
- **Haken:** Validate-Runs auf #11 stehen auf `action_required` (leere Jobs) — Fork-PR-Schutz: Der Upstream-Besitzer muss den
  Workflow-Run erst freigeben. Kann nur der Freund klicken.
- **Aktion:** Status-Kommentar auf #11 hinterlegt (Inhalt des Updates + Hinweis auf Freigabe).
  Merge-Entscheidung liegt beim Besitzer. Kein Code, kein Eingriff in Builds.
- **Tests:** keine (Remote-Abfragen).

## 2026-10-16 — Upstream alpha.15/16 gemergt, Doku auf Quellenstand gebracht (Fork)

- **Bereich:** `git fetch origin` → zwei neue Commits (`6554985` PR#18, `0ee41f3` PR#19) + Tags
  `v0.1.0-alpha.15`/`v0.1.0-alpha.16`; Merge in Docs-Branch **konfliktfrei** (25 Dateien, +236/−50).
- **Upstream-Änderungen (Codex):** Live-Installer in der Live-Session (Autostart + Desktop-Shortcut,
  `lokro-live-installer`, Polkit-Regel nur für `liveuser`), Calamares-Launch via Upstream-Polkit-Action
  statt `sudo -E` (alpha.16), früher Installer-Exit im Smoke-Watcher (Gate = Plasma + Calamares-Prozess),
  LOKRO-Hub-Fix (finale `icon`-Property), Store-Pin `v0.1.0-alpha.6` (Flathub-Repair, ArtCraft 0.3.2-Bundle
  SHA-pinned, `.lokrodesign`-Download), Design-Pack-Dialog öffnet Store-Katalog, `docs/DESIGN_REFERENCES.md`
  neu (monochrom/schwarz-weiß, Halbton-Texturen; Referenzen ohne Lizenz), VERSION/Update-Kanal → alpha.16.
- **Release-Wahrheit:** alpha.15 baute ISOs und bestand Size-Gate, aber das BIOS-Rauch-Gate scheiterte
  am `sudo -E`-Launcher → **keine Alpha.15-Veröffentlichung** (korrekt). Alpha.14 bleibt letztes
  verifiziertes Release; alpha.16 ist Quellenkandidat ohne CI-Nachweis.
- **Doku-Folgen:** `AGENTS.md` (Stand alpha.16 + Verifizierungsstatus, Live-Installer im Overlay-Eintrag),
  `IDEAS.md` (F31 Store v0.1.0-alpha.6), `TODO.md` (Header, Tests-Zeilen, neuer P2-Eintrag „Alpha.16-CI-Gate
  beobachten"), `docs/KNOWN_ISSUES.md` (neu **KI-009**: alpha.15-Launchpfad, Quelle-Fix da, CI ausstehend;
  Header auf alpha.16).
- **Tests (diese Umgebung):** `validate.mjs` ✅ 68 Dateien/103 Pakete; `unittest` ✅ 6/6; `bash -n` ✅.
  Kein Code, keine Builds, kein `origin`-Eingriff. Offene PRs #11/#17 unverändert offen.

## 2026-10-17 — F35 Grundstein: Custom Taskbar/Dock (iOS-Dock × Glass)

- **Anlass:** Videofeedback des Projektverantwortlichen — System bootet, Stock-Panel sichtbar mit
  „komischem Logo" links (Kickoff-Fallback, kein `lokro-os`-Icon im Repo) und eckiger Leiste. Wunsch:
  eigene Taskbar, Apple-iOS-Navbar × LOKRO-Glass (zentriert, gerundet, große Icons, App-Name bei
  Hover, cleane Animationen).
- **Recherche (nur lesen):** keine Panel-Config im Repo (kein `appletsrc`/`layout.js`/`[Panel]`),
  einziges Eingreifen `lokro-first-login` (`org.lokro.search` an Panel angehängt), `kwinrc` ohne
  `[Effect-blur]`, Plasmoid-Blaupausen `org.lokro.search`/`org.lokro.hub` vorhanden,
  Design-Packs dürfen kein QML. Ergebnisse in `docs/AI_NOTES_opencode_2026-10-17.md` (§2).
- **Angelegt:**
  1. `docs/adr/0003-lokro-dock.md` (Vorschlag): Plasma-Applet + LnF-Panel-Layout + KWin-Blur statt
     Standalone-layer-shell-Dock oder Theme; Hyprland behält Waybar.
  2. `docs/AI_NOTES_opencode_2026-10-17.md`: Design-Spezifikation (Maße, Tokens F34, Animationen)
     + offene Fragen (Kickoff raus?, Pinned-Default, Panel-Default-Weg, Blur-Verifikation).
  3. Prototyp `packages/lokro-shell/experimental/org.lokro.dock/` (`metadata.json`, `main.qml` mit
     `TaskManager.TasksModel`, Glass-Rectangle, Hover-Scale/Halo/Tooltip/Laufpunkt, Eingangs-Animation).
     **Bewusst außerhalb von `rootfs/`** → wird nicht gepackt (PKGBUILD kopiert nur `rootfs/.`).
  4. Doku: `IDEAS.md` F35 (IN_PROGRESS, Steckbrief + Notizen-Verzeichnis-Eintrag), `TODO.md` P2,
     `AGENTS.md` Strukturzeile `lokro-shell` (`experimental/`-Hinweis).
- **Ehrlichkeit:** Nichts davon ist getestet (`qmllint`/Plasma-VM hier nicht verfügbar), nichts im ISO,
  kein „fertig"-Anspruch. Status IN_PROGRESS.
- **Tests:** `node scripts/validate.mjs` ✅ (68 Dateien, 103 Pakete), `unittest` ✅ 6/6, `bash -n` ✅.

## 2026-10-19 - Arbeitsaufnahme: Fork Sync + Planung Splash/OOBE + ISO-Build

- **Anlass:** Nutzerauftrag: Fork (lokroos-Projektordner) auf jamjam1312/LOKROOS-Arch-based aktualisieren (Remote bereits umgestellt, fork-gebrandete URL ersetzt; Upstream diffs untersucht), dann bootable ISO bauen, bei Bedarf GH Releases beachten. Zudem Splash-Screen und Einrichtungsassistent (OOBE/setup wizard) umsetzen, und alle neuen �nderungen in Dokus einpflegen. KI-Dokumentationspflicht: alles dokumentieren in jeweiligen MD-Dateien.
- **Synchronisation:** Upstream fetch + merge (--no-ff) von etch_head (commit 215431e) nach 1640b5; gelandet bei 90158a. Dateien wie docs/RELEASE_STATUS.md (alpha.21-Referenzen), neue Credits/CODEOWNERS, Installer-Supervisor, etc. sind jetzt lokal. 
ode scripts/validate.mjs ergibt: Validated 74 required files, 103 package entries across three profiles, and JSON/config invariants.
- **Vorhandene Arbeitsteilung:** andere bauen Desktop-Geschichte (Codex + Mitstreiter), wir beide machen Einrichtungsassistent, Splash-Screen, Settings. Repo hat bereits erste Ans�tze: ADR 0002 (shared first-boot wizard), F35 Dock grundgelegt. Auch Live-Installer-Mechanik existiert (lokro-live-installer + supervisor). Einrichten/OOBE und Plymouth/Splash zu pr�fen.
- **Erkenntnis:** To build a bootable ISO on this Arch-based repo, use make iso-offline / make iso-online after make packages on an Arch Linux host (mkarchiso). Build host must be Arch; on Windows not possible natively. Can prepare locally (docs/validate) but ISO build requires Arch.
- **Nächster Schritt:** Repo-Status scannen (OOBE, splash/plymouth, settings/wizard), Upstream auf neue Commits/Tags checken (jamjam1312), dann Dokus aktualisieren und je nach Umgebung entweder auf Arch-Host verlagern oder Build-Plan detaillieren. Als erste konkrete Aktion: OOBE/Setup-Wizard und Splash/Plymouth im Repo finden und bewerten.
## 2026-10-19 - Arbeitsaufnahme: Fork Sync + Planung Splash/OOBE + ISO-Build

- **Anlass:** Nutzerauftrag: Fork (lokroos-Projektordner) auf jamjam1312/LOKROOS-Arch-based aktualisieren (Remote bereits umgestellt, fork-gebrandete URL ersetzt; Upstream diffs untersucht), dann bootable ISO bauen, bei Bedarf GH Releases beachten. Zudem Splash-Screen und Einrichtungsassistent (OOBE/setup wizard) umsetzen, und alle neuen �nderungen in Dokus einpflegen. KI-Dokumentationspflicht: alles dokumentieren in jeweiligen MD-Dateien.
- **Synchronisation:** Upstream fetch + merge (--no-ff) von FETCH_HEAD (commit 215431e) nach b1640b5; gelandet bei b90158a. Dateien wie docs/RELEASE_STATUS.md (alpha.21-Referenzen), neue Credits/CODEOWNERS, Installer-Supervisor, etc. sind jetzt lokal. node scripts/validate.mjs ergibt: Validated 74 required files, 103 package entries across three profiles, and JSON/config invariants.
- **Arbeitsteilung:** andere bauen Desktop-Geschichte (Codex + Mitstreiter), wir beide machen Einrichtungsassistent, Splash-Screen, Settings. Repo hat bereits Ans�tze: ADR 0002 (shared first-boot wizard), F35 Dock grundgelegt. Live-Installer existiert (lokro-live-installer + supervisor).
- **Erkenntnis:** Zum Bauen einer bootable ISO auf diesem Arch-based Repo wird mkarchiso ben�tigt, d.h. Build auf Arch-Linux-Host (VM/Container). Auf Windows nativ nicht m�glich. Dokus/Validierung lokal ok. GH Releases: alpha.21 existiert laut RELEASE_STATUS.md als aktueller CI-Release.
- **Nächster Schritt:** OOBE/Setup-Wizard und Splash/Plymouth im Repo finden und bewerten, Upstream auf neue Commits/Tags checken, dann Dokus aktualisieren. Für Splash/OOBE konkrete Dateien identifizieren (ADR 0002, lokro-shell packages, branding, archiso airootfs).
## 2026-10-19 - Arbeitsaufnahme: Fork Sync + Planung Splash/OOBE + ISO-Build

- **Anlass:** Nutzerauftrag: Fork auf jamjam1312/LOKROOS-Arch-based aktualisieren, bootable ISO bauen, bei Bedarf GH Releases beachten. Splash-Screen und Einrichtungsassistent (OOBE/setup wizard) umsetzen. Alles in MD-Dateien dokumentieren (KI-Pflicht).
- **Sync:** Upstream fetch + merge --no-ff (FETCH_HEAD 215431e) -> b90158a. docs/RELEASE_STATUS.md zeigt alpha.21, neue Credits/CODEOWNERS, Installer-Supervisor. 
ode scripts/validate.mjs: 74 files, 103 package entries valid.
- **Aufteilung:** Desktop von anderen (Codex+Mitstreiter), wir machen OOBE, Splash, Settings. ADR 0002 exists, F35 Dock groundwork, Live-Installer exists.
- **ISO-Build:** requires mkarchiso on Arch Linux host (VM/Container). Windows native not possible. GH Releases include multipart ISOs for releases; need to build if not present.
- **Plan:** OOBE/Setup-Wizard (ADR 0002, lokro-shell, calamares branding?) and Splash/Plymouth locate, assess, implement as needed, document in MD files, update docs to reflect changes. Also check upstream for new commits/tags.
## 2026-10-19 - Analyse Splash/OOBE/Settings

- **Splash/Plymouth:** Branding hat lokro Plymouth-Theme; archiso common.x86_64 enth�lt plymouth. Vorhanden.
- **Welcome:** Dashboard in lokro-shell/welcome/main.qml (kein mehrstufiger Wizard). ADR 0002 Konzept f�r gemeinsamen OOBE.
- **OOBE fehlt:** Konkrete Implementierung noch nicht da. Vorschlag: Wizard unter packages/lokro-shell/rootfs/usr/share/lokro/wizard/ anlegen (QML-Komponenten), first-run Trigger (lokro-first-login oder eigenes Skript), Doku in AI_NOTES, ADR 0002 ggf. aktualisieren.
- **Settings:** Plasma-Standard, lokro-spezifisch noch unklar. Fokus erstmal OOBE + Splash-Verbesserung gem. Aufgabenteilung.
## 2026-10-19 - Planung: OOBE/Wizard + Splash (nächste Schritte)

- **ISO-Build-Umgebung:** mkarchiso nur auf Arch Linux. Auf Windows nicht ausf�hrbar. Wir k�nnen nur vorbereiten (Dokus, Code, validate). Falls gew�nscht, auf Arch-Host (VM/Container) verlagern oder Build dorthin delegieren.
- **Upstream-Check:** Lokal auf HEAD von jamjam1312 bereits geholt (b90158a merged). Keine neuen Commits seit FETCH_HEAD vs HEAD festgestellt. Kann bei Bedarf regelm��ig fetchen.
- **OOBE-Implementierung (Vorschlag):**
  1. AI_NOTES_opencode_2026-10-19.md anlegen (Dokumentationspflicht)
  2. Wizard-Struktur in packages/lokro-shell/rootfs/usr/share/lokro/wizard/ (StepContainer, pages)
  3. Trigger: lokro-first-login oder XDG autostart f�r 'lokro-wizard' (Desktop-First-Run nach Installation/Live-Setup)
  4. ADR 0002 evtl. auf 'proposed/accepted' je nach Implementierungsumfang aktualisieren
  5. TODO.md erweitern (P1/P2)
  6. DEVELOPMENT_LOG + AI_NOTES pflegen
- **Splash:** Plymouth-Theme existiert. Pr�fen, ob Verbesserungen n�tig (Animation, Assets). Evtl. kleine Anpassungen.
- **Dokumentation:** Alle �nderungen konsequent in zugeh�rigen MDs eintragen.
## 2026-10-19 - AI_NOTES erstellt + OOBE/Wizard Struktur geplant

- **AI_NOTES_opencode_2026-10-19.md** angelegt: Auftrag, Ist-Stand, Vorschlag f�r OOBE/Wizard (Struktur unter lokro-shell/wizard), Splash-Review, Settings-Fokus, ISO-Build-Plan, n�chste Schritte, Dokumentationspflicht.
- **Fokus:** OOBE + Splash + Settings gem�� Arbeitsteilung. Wizard klar vom Live-Installer getrennt (erst im installierten Zielsystem beim ersten Login).
- **Nächster Schritt:** Wizard-Verzeichnisstruktur und Basis-QML (StepContainer + erste Seiten) anlegen.
## 2026-10-19 - OOBE/Wizard-Prototyp angelegt

- **packages/lokro-shell/rootfs/usr/share/lokro/wizard/** erstellt: StepContainer.qml, main.qml, pages/WelcomePage.qml, ThemePage.qml, FinishPage.qml. Minimaler mehrstufiger Wizard mit SwipeView, PageIndicator, Navigation (Zur�ck/Weiter/�berspringen), konzeptionelles Finish-Flag.
- **packages/lokro-shell/rootfs/usr/bin/lokro-wizard** erstellt (Starter-Skript mit flock + First-Run-Flag ~/.config/lokro/wizard-done).
- **Ziel:** Mobile-first-kompatible Komponenten (ADR 0002). Kein Eingriff in Live-Installer/Calamares. Nur f�r installiertes Zielsystem gedacht.
## 2026-10-19 - Dokus aktualisiert (AI_NOTES + DEVELOPMENT_LOG + Planung)

- AI_NOTES_opencode_2026-10-19.md: Vollst�ndige Analyse, Vorschlag, ISO-Build-Plan, n�chste Schritte, Dokumentationspflicht.
- DEVELOPMENT_LOG.md: Sync, Analyse, Planung, Wizard-Prototyp.
- Wizard-Prototyp erstellt (StepContainer, 3 Seiten, Starter). Kein Code-Package-Eintrag noch nicht angepasst (experimental/ und rootfs/ separiert).
- validate.mjs weiterhin gr�n (74 files, 103 entries).
## 2026-10-19 - Upstream-Check + ISO-Build-Hinweis

- Upstream (jamjam1312/LOKROOS-Arch-based) erneut geholt: FETCH_HEAD==HEAD (215431e), keine neuen Commits. Fork ist aktuell.
- ISO-Build erfordert mkarchiso auf Arch Linux Host. Auf Windows nicht m�glich. Build kann auf Arch-VM/Container durchgef�hrt werden. GH Releases beachten (alpha.21 als aktueller Release laut RELEASE_STATUS.md).
- OOBE/Wizard-Prototyp erstellt gem�� Aufgabenteilung (wir beide machen Einrichtungsassistent, Splash, Settings). Splash/Plymouth existiert bereits - k�nnen bei Bedarf verfeinern.
- Dokumentation konsequent in AI_NOTES_opencode_2026-10-19.md + DEVELOPMENT_LOG.md gepflegt.
