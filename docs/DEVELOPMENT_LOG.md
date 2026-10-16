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
