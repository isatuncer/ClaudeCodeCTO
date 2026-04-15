# ClaudeCodeCTO

> **Sprache:** [English](../../README.md) · [Türkçe](../../README.tr.md) · **Deutsch** · [Español](README.es.md) · [Français](README.fr.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [中文](README.zh-CN.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

> Verwandeln Sie Claude Code in einen vollständigen CTO: 3.025 handverlesene Skills, Agents und Commands aus 17 führenden Open-Source-Repositories, installiert in `~/.claude/` ohne externe Kosten.

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](../../LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-8A2BE2)](https://docs.claude.com/en/docs/claude-code)
[![Components](https://img.shields.io/badge/Components-3025-green.svg)](../../decisions/selected.json)

---

## Was ist das?

ClaudeCodeCTO ist ein **Kuratierungs- und Installationssystem**, das die besten Skills, Agents und Commands aus 15 öffentlichen Claude-Code-Repositories nimmt und als einheitliches Toolkit in Ihr `~/.claude/`-Verzeichnis installiert.

Das Ergebnis: eine Claude-Code-Installation, die Sie **von der Idee bis zur Produktion** führt — durch Discovery, Planning, Design, Build, Test, Dokumentation, Shipping und Wartung — mit spezialisierten Agents in jeder Phase.

Stellen Sie es sich vor wie einen CTO für Ihr Projekt: einer, der jedes Framework, jede Teststrategie und jedes Deployment-Pattern kennt und genau weiß, welcher Spezialist in jedem Schritt aufgerufen werden muss.

---

## Schnellstart — Ein Befehl

```bash
curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

Oder mit `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

Standard-Zielverzeichnis ist `$HOME/ClaudeCodeCTO`. Zum Überschreiben:

```bash
CCCTO_DIR=/eigener/pfad bash <(curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh)
```

### Manueller Start

```bash
git clone https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO
git submodule update --init --recursive
bash scripts/setup.sh
```

### Umgebungsvariablen

| Variable | Standard | Beschreibung |
|---|---|---|
| `CCCTO_DIR` | `$HOME/ClaudeCodeCTO` | Ziel-Klonverzeichnis |
| `CCCTO_BRANCH` | `main` | Zu klonender Branch |
| `CCCTO_AUTO` | `0` | `1` = nicht-interaktiver Modus |
| `CCCTO_NO_INSTALL` | `0` | `1` = `~/.claude/`-Installation überspringen |

---

## Features

- **3.025 Komponenten** — 2.044 Skills + 550 Agents + 431 Commands aus 17 Repos kuratiert
- **8-Phasen-Lifecycle** — Discovery → Planning → Design → Build → Test → Document → Ship → Maintain
- **Null externe Kosten** — keine Anthropic-API-Aufrufe, keine bezahlten Dienste, keine Telemetrie
- **Factory-Reset-kompatibel** — funktioniert auf einem sauberen `~/.claude/`, bewahrt `.credentials.json`
- **Atomische Installation mit Backup** — alles zuerst in `/c/tmp/` gestaged, dann committed
- **Standardmäßig interaktiv** — bestätigt jede destruktive Aktion; `--auto` für CI
- **Fortsetzbar** — Pipeline-Stufen schreiben in `decisions/`, können von jedem Checkpoint neu starten
- **Single Source of Truth** — nur `decisions/` ist maßgeblich; keine versteckte Config
- **Windows + Linux + macOS** — pfadbewusst (verwendet `cygpath` unter Windows)

---

## Was wird installiert?

```
~/.claude/
├── .credentials.json              (unverändert)
├── CLAUDE.md                      globale Anweisungen (generiert)
├── settings.json                  Harness-Config (generiert)
├── skills/                        2.044 Skills
│   └── project-lifecycle/         Meta-Orchestrator (8-phasig)
├── agents/                        550 spezialisierte Agents
├── commands/                      431 Slash-Commands
│   └── start-project.md           /start-project Lifecycle-Einstieg
├── rules/
│   └── agent-decision-tree.md     welcher Agent für welche Aufgabe
└── config/
    └── lifecycle.json             8-Phasen-Projektkarte
```

**Aufschlüsselung nach Domäne:**

| Domäne | Anzahl | Beispiele |
|---|---:|---|
| devops | 541 | docker, kubernetes, terraform, CI/CD |
| project-mgmt | 349 | planning, OKRs, Sprint-Workflows |
| frontend | 333 | React, Vue, Next.js, Design Systems |
| coding | 287 | sprachspezifische Builder und Reviewer |
| backend | 183 | APIs, Datenbanken, Microservices |
| security | 143 | Auditing, Pen-Testing, Compliance |
| testing | 140 | Unit, Integration, E2E, Mutation |
| data-ai | 132 | ML-Pipelines, LLM-Integration, RAG |
| docs | 120 | Technical Writing, API-Referenz |
| architecture | 81 | C4-Diagramme, ADRs, Systemdesign |
| other | 79 | Verschiedenes |

Ein Backup des vorherigen `~/.claude/` wird automatisch unter `/c/tmp/claude-install-backup-<timestamp>/` gespeichert, bevor Änderungen vorgenommen werden.

---

## Der 8-Phasen-Projekt-Lifecycle

Nach der Installation aktiviert `/start-project` in einer neuen Claude-Code-Session den Lifecycle-Orchestrator.

| Phase | Name | Motto | Haupt-Agents |
|---|---|---|---|
| 1 | Discovery | "Was und warum?" | business-analyst, market-researcher, ux-researcher |
| 2 | Planning | "Wie bauen wir es?" | planner, architect, product-manager |
| 3 | Design | "Wie sieht es aus?" | ui-designer, api-designer, database-architect |
| 4 | Build | "Code schreiben" | fullstack/frontend/backend-developer, tdd-guide |
| 5 | Test | "Funktioniert es?" | test-automator, qa-expert, e2e-runner |
| 6 | Document | "Wie wird es benutzt?" | technical-writer, api-documenter |
| 7 | Ship | "Wie geht es live?" | deployment-engineer, devops-engineer, sre-engineer |
| 8 | Maintain | "Wie bleibt es gesund?" | performance-engineer, security-engineer, refactor-cleaner |

Jede Phase ist fortsetzbar. Wenn Sie die Session schließen, merkt sich `decisions/project-state.json`, wo Sie waren.

---

## Kuratierungs-Pipeline

Die 9-stufige Pipeline erstellt `decisions/selected.json`. Sie läuft nur auf dem Rechner des Maintainers — Endbenutzer sehen sie nie.

```
1. DISCOVER     TSV-Inventar der Rohkomponenten
2. EXTRACT      catalog.json mit reichhaltigen Metadaten
3a. SCORE       100-Punkte-deterministisches Rubric
3b. SELF-SCORE  semantisches Scoring via Claude-Code-Subagents
4. CURATE       Dedupe + Domänen-Gruppierung → selected.json
4.5 ORCHESTRATE 8-Phasen-Lifecycle-Bindung
4.6 BUDGET      Token-Kostenprofil (~105K Startup)
4.7 VALIDATE    22 Overlap-Paare → Entscheidungsbaum
5. INSTALL      atomische Staged-Installation + Backup
5.5 SMOKE TEST  8-Test strukturelle Verifikation
6. OPTIMIZE     nutzungsbasiertes Pruning (optional)
```

### 100-Punkte-Rubric

| Dimension | Punkte | Was wird gemessen |
|---|---:|---|
| Strukturell | 30 | Gültiges YAML-Frontmatter, erforderliche Felder, Größenlogik |
| Inhalt | 30 | Beschreibungslänge, Beispiele, klare Auslösebedingungen |
| Cross-Repo | 20 | Einzigartigkeit; Aktualität |
| Domänen-Fit | 20 | Bonus für Prioritätsdomänen |

---

## Quell-Repositories

17 aktive Submodules. Alle Lizenzen bleiben erhalten.

| Repository | Fokus | Skills | Agents | Commands |
|---|---|---:|---:|---:|
| [anthropics/skills](https://github.com/anthropics/skills) | Offizielle Anthropic Skills | 19 | 0 | 0 |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | Allround-Toolkit | 183 | 47 | 82 |
| [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) | Massive Skill-Sammlung | 1.404 | 0 | 0 |
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | Domänen-Spezialisten | 0 | 24 | 33 |
| [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | Kuratierte Subagents | 0 | 140 | 0 |
| [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) | Vollständiges Toolkit | 35 | 138 | 243 |
| [parcadei/Continuous-Claude-v3](https://github.com/parcadei/Continuous-Claude-v3) | Continuous-Dev-Workflow | 156 | 32 | 0 |

Vollständige Liste in [`.gitmodules`](../../.gitmodules).

---

## Anforderungen

- **Claude Code** mit Anmeldedaten in `~/.claude/.credentials.json`
- **Python 3.8+** mit `PyYAML` (automatische Installation durch `install.sh`)
- **Bash** 4+ (git-bash unter Windows)
- **Git** mit Submodule-Unterstützung
- **~1 GB freier Speicher** für Submodules + generierte Artefakte
- **~5–15 Min** erstmalige Einrichtung

Unterstützte Plattformen: Windows (git-bash), macOS, Linux.

---

## Deinstallation

```bash
cd ClaudeCodeCTO
bash scripts/uninstall.sh --dry-run   # Vorschau, was entfernt würde
bash scripts/uninstall.sh             # tatsächlich entfernen
```

Das Skript liest `decisions/install.tsv` und entfernt **nur**, was ClaudeCodeCTO installiert hat.

**Geschützt — wird nie angefasst:** `~/.claude/.credentials.json` (dein Claude Code Login), `~/.claude/projects/` (projektbezogenes Gedächtnis), selbst hinzugefügte Komponenten und `CLAUDE.md`/`settings.json`, wenn du sie bearbeitet hast.

Flags: `--dry-run`, `--yes`/`-y`, `--keep-generated`.

---

## Fehlerbehebung

### Setup schlägt bei "Environment Check" fehl

```bash
pip install pyyaml
```

### Submodule-Pull schlägt fehl

```bash
git submodule sync
git submodule update --init --recursive --force
```

### Installation schlägt mittendrin fehl

Backup liegt unter `/c/tmp/claude-install-backup-<timestamp>/`. Wiederherstellung:

```bash
rm -rf ~/.claude/skills ~/.claude/agents ~/.claude/commands
cp -r /c/tmp/claude-install-backup-<timestamp>/. ~/.claude/
```

### Claude Code sieht die neuen Skills nicht

Starten Sie eine **frische Claude-Code-Session**. Der System-Prompt wird beim Session-Start eingefroren.

---

## FAQ

**F: Warum ist das "kostenlos"? Claude Code nutzt doch meine API-Credits, oder?**
Ja — Claude Code nutzt Ihre bestehende Session. Was "null Kosten" bedeutet: diese Pipeline hat keine separaten Anthropic-API-Keys, keine Drittanbieter-Dienste, keine bezahlte Bewertung.

**F: Überschreibt das mein bestehendes `~/.claude/`?**
Nein — der Installer sichert zuerst alles unter `/c/tmp/claude-install-backup-<timestamp>/`, dann staged er in `/c/tmp/claude-install-stage-<timestamp>/`, dann kopiert er Dateien. Bei Problemen können Sie vom Backup wiederherstellen.

**F: Kann ich wählen, welche Komponenten installiert werden?**
Ja — bearbeiten Sie `decisions/selected.json` vor dem Ausführen von `setup.sh`.

**F: Was sind die Token-Kosten für das Laden von 2.044 Skills?**
Etwa **105K Tokens** beim Session-Start. Die meisten Skills werden lazy geladen, wenn sie ausgelöst werden.

---

## Lizenz

MIT — siehe [LICENSE](../../LICENSE).

## Danksagungen

Dieses Projekt kuratiert Inhalte aus 17 Open-Source-Repositories. Siehe [`.gitmodules`](../../.gitmodules) für die vollständige Liste. Alle Submodule-Lizenzen bleiben in den jeweiligen `sources/<repo>/`-Verzeichnissen erhalten.

Gebaut von [@isatuncer](https://github.com/isatuncer). PRs und Issues willkommen.
