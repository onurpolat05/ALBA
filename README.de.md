<p align="center">
  <img src="assets/banner.png" alt="ALBA – Ihr routinebasierter KI-Begleiter" width="100%">
</p>

<p align="center">
  <a href="README.md">English</a> | <a href="README.tr.md">Türkçe</a> | <b>Deutsch</b>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <a href="https://docs.claude.com/en/docs/claude-code"><img src="https://img.shields.io/badge/Claude%20Code-v2.1.218+-purple.svg" alt="Claude Code minimum"></a>
  <a href="https://github.com/anthropics/claude-code/releases"><img src="https://img.shields.io/badge/Tested-v2.1.220-green.svg" alt="Getestet mit v2.1.220"></a>
  <a href="https://github.com/onurpolat05/ALBA/stargazers"><img src="https://img.shields.io/github/stars/onurpolat05/ALBA?style=social" alt="Stars"></a>
</p>

---

ALBA verwandelt Claude Code in einen **persönlichen KI-Agenten**, der sich Ihre Prioritäten merkt, aus Ihren Fehlern lernt und sich an Ihren Arbeitsablauf anpasst — egal ob Sie Entwickler, Projektmanager, Forscher, Gründer oder Content Creator sind.

**10 Minuten interaktives Setup. Kein Paketmanager, kein Build-Schritt, nichts, das dauerhaft läuft — Bash-Skripte und Markdown-Dateien.**

<p align="center">
  <img src="assets/demo.gif" alt="ALBA /setup Demo" width="100%">
</p>

## Das Problem

Jede neue Claude Code Sitzung beginnt bei null. Keine Erinnerung an die Prioritäten von gestern. Kein Kontext zu Ihren Projekten. Dieselben Fehler wiederholen sich. Sie erklären Ihren Arbeitsablauf jedes Mal von Neuem.

## Die Lösung

```
you@machine:~/alba$ claude
> /setup
```

Beantworten Sie 7 Fragen. ALBA erstellt ein personalisiertes Agentensystem mit persistentem Speicher, automatisierten Workflows und selbstverbesserndem Verhalten — zugeschnitten auf Ihre Rolle.

## Was Sie erhalten

```
your-agent/
├── CLAUDE.md                     # Agent-Kern (< 200 Zeilen)
├── memory/
│   ├── state/                    # Prioritäten, Aufgaben (jede Sitzung aktualisiert)
│   ├── knowledge/                # Erkenntnisse, Fehler, Präferenzen (automatisch aktualisiert)
│   ├── projects/                 # Projektspezifischer Kontext
│   └── daily/                    # Sitzungsprotokolle (automatisch erstellt)
├── .claude/
│   ├── skills/                   # 9 integrierte Skills
│   ├── hooks/                    # 8 automatisierte Event-Handler
│   ├── agents/                   # Subagent-Definitionen
│   ├── rules/                    # Verhaltensrichtlinien (automatisch geladen)
│   ├── docs/                     # Referenzdokumentation (lazy-loaded)
│   └── settings.json             # Hook-Konfiguration + Berechtigungen
```

## Kernfunktionen

### Persistenter Speicher
Dateibasierter Drei-Schichten-Speicher, der sitzungsübergreifend erhalten bleibt. Git-versioniert, menschenlesbar, keine Abhängigkeiten.

```
/start              → lädt Ihre Prioritäten aus der letzten Sitzung
  ... Arbeit ...
/end                → speichert Fortschritt, erfasst Erkenntnisse
  ... nächster Tag ...
/start              → macht genau dort weiter, wo Sie aufgehört haben
```

### 9 integrierte Skills

| Skill | Zweck |
|-------|-------|
| `/start` | Sitzung starten — Kontext laden, Prioritäten anzeigen |
| `/end` | Sitzung beenden — Zustand speichern, Tagesprotokoll erstellen |
| `/status` | Schnellübersicht — Aufgaben, Blocker, letzte Sitzung |
| `/research` | Webrecherche mit strukturierter Ausgabe (läuft als Subagent) |
| `/weekly-review` | Wöchentliche Leistungsauswertung und Planung der nächsten Woche |
| `/extend` | Jederzeit neue Skills, Hooks oder Rules hinzufügen |
| `/reflect` | Sitzungsübergreifende Musteranalyse |
| `/create-skill` | Geführter Skill-Erstellungsassistent |
| `/setup` | Interaktive Ersteinrichtung |

### 8 automatisierte Hooks

| Claude Code Event | Script | Was passiert |
|---|---|---|
| `SessionStart` | `session-start.sh` | Dashboard wird geladen, Prioritäten angezeigt |
| `UserPromptSubmit` | `agent-suggest.sh` | Passender Skill wird zu dem vorgeschlagen, was Sie gerade getippt haben |
| `PreToolUse` | `bash-validator.sh` | Destruktiver Befehl wird abgelehnt, bevor er läuft |
| `PostToolUse` | `error-logger.sh` | Bash-Fehler werden zur Mustererkennung protokolliert |
| `PostToolUseFailure` | `error-logger.sh` | Edit-, Write- und MCP-Fehler ebenfalls protokolliert |
| `Stop` | `memory-check.sh` | Erinnerung, den Zustand zu speichern — mit Rate-Limit, nicht bei jedem Turn |
| `SessionEnd` | `session-end.sh` | Sachlicher Eintrag im heutigen Protokoll, auch wenn Sie `/end` überspringen |
| `PreCompact` / `PostCompact` | `pre-compact.sh`, `post-compact.sh` | Prioritäten überstehen die Context Compaction |

Neun Registrierungen, acht Skripte — `error-logger.sh` ist an beide Tool-Fehler-Events gebunden.

**Zum Validator:** Er lehnt eine kurze Liste tatsächlich destruktiver Befehle ab und schweigt zu allem anderen. Schweigen heißt *schweigen* — keine Ausgabe, Exit 0, normaler Berechtigungsablauf. Ein `PreToolUse` Hook, der mit `"allow"` antwortet, überspringt Ihren Berechtigungs-Prompt vollständig; ein Validator, der alles durchwinkt, was seine Blocklist verfehlt hat, ist damit kein Sicherheitsnetz, sondern ein Loch. ALBA hat dieses Loch bis v2.0.0 mitgeschleppt.

### Selbstverbesserung

ALBA lernt aus Ihrer Arbeit:
- **Fehler** werden automatisch mit Lösungen erfasst (derselbe Fehler wiederholt sich nie)
- **Erkenntnisse** werden als wiederverwendbare Muster gespeichert
- **Präferenzen** werden aktualisiert, wenn Sie den Agenten korrigieren
- **`/reflect`** analysiert sitzungsübergreifende Muster und schlägt neue Rules vor

### Progressive Disclosure

CLAUDE.md bleibt unter 200 Zeilen. Systemdokumentation wird nur bei Bedarf nachgeladen — für ein effizientes Kontextfenster.

---

## Schnellstart

### Option 1: GitHub Template (Empfohlen)

Klicken Sie auf **"Use this template"** auf GitHub, dann:

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git my-agent
cd my-agent
claude
```

### Option 2: Direktes Klonen

```bash
git clone https://github.com/onurpolat05/ALBA.git my-agent
cd my-agent
rm -rf .git && git init
claude
```

### Dann:

```
/setup
```

Beantworten Sie 7 Fragen (~10 Minuten). Ihr personalisierter Agent ist bereit.

**Bestätigen Sie den Trust-Dialog, wenn Sie den Ordner zum ersten Mal öffnen.** Bis dahin ignoriert Claude Code die `permissions.allow`-Liste in `settings.json` — Hooks laufen weiterhin, aber Sie werden für Lesezugriffe und Befehle gefragt, die eigentlich still durchgehen sollten. Das wirkt weniger wie ein nicht vertrauenswürdiger Ordner als wie ein kaputtes Setup.

---

## Täglicher Arbeitsablauf

```
Morgens:
  /start                    # "Ihre Prioritäten: 1. API-Deadline Freitag  2. PR #42 reviewen"

Während der Arbeit:
  "research multi-agent patterns"    # /research läuft als Subagent
  "what's my status?"                # /status zeigt Schnellübersicht

Feierabend:
  /end                      # Speichert Fortschritt, erfasst Erkenntnisse, erstellt Tagesprotokoll

Freitag:
  /weekly-review            # Analysiert die Woche, plant die nächste

Jederzeit:
  /extend                   # "Ich möchte einen Content-Creation-Skill" → wird erstellt
  /loop 30m /status         # Periodische Erinnerungen, sitzungsbezogen
```

---

## Vergleich

| Funktion | Claude Code pur | Andere Starter | ALBA |
|----------|----------------|----------------|------|
| Sitzungsübergreifender Speicher | Keiner | Teilweise (nur Speicher) | 3-Schichten (State/Knowledge/Projects) |
| Setup-Erfahrung | Manuelle Konfiguration | Copy-Paste | Interaktiver Assistent (7 Fragen) |
| Rollenunterstützung | Generisch | Nur Entwickler | Jede Rolle (5 Beispiele enthalten) |
| Selbstverbesserung | Nein | Nein | Automatische Fehler- und Erkenntniserfassung |
| Hooks | Manuelles Setup | Einige Templates | 8 Hooks, automatisch konfiguriert |
| Skills | Keine integrierten | Variiert | 9 integrierte, erweiterbar |
| Kontexteffizienz | N/A | N/A | Progressive Disclosure (< 200 Zeilen) |
| Konfigurations-Check | `/doctor` (Ihre Installation) | Nein | `tools/doctor.sh` (die Konfiguration selbst) |

---

## Beispiele

Unter `examples/` finden Sie vollständige, funktionierende Konfigurationen:

| Rolle | Schwerpunkt |
|-------|-------------|
| **[Developer](examples/developer/)** | Code-Projekte, Git-Workflows, Recherche |
| **[Project Manager](examples/project-manager/)** | Sprint-Management, Stakeholder-Updates, Teamkoordination |
| **[Content Creator](examples/content-creator/)** | Content-Kalender, Recherche, Multi-Plattform-Publishing |
| **[Researcher](examples/researcher/)** | Literaturrecherche, Quellenverwaltung, Zitatverfolgung |
| **[Founder](examples/founder/)** | Multi-Client-Management, Umsatzverfolgung, Personal Brand |

Jedes Beispiel enthält vorgefüllte Dashboards, exemplarische Tagesprotokolle und funktionsfähige Hook-Konfigurationen.

---

## Architektur

### Skills

Skills sind Markdown-Dateien mit YAML-Frontmatter. Die `description` ist keine Dekoration — sie ist das Einzige, was Claude liest, wenn es entscheidet, ob ein Skill aufgerufen wird. Deshalb sagen ALBAs Descriptions beides: wann ein Skill auslösen soll und wann nicht.

```yaml
---
name: research
description: Structured web research with cited sources. Use when user says
  "research X", "look into X". Do NOT use for single-fact lookups.
context: fork              # runs in a subagent, main context stays clean
agent: general-purpose     # which subagent type the fork uses
background: false          # wait for the result in this turn (see below)
effort: medium
argument-hint: <topic> [deep]
allowed-tools: [Read, Write, Glob, Grep, WebSearch, WebFetch]
---
```

`context: fork` = aufwändige Aufgaben laufen als Subagents. `context: inline` = schnelle Aufgaben in der Hauptkonversation.

**Die `background`-Falle.** Seit Claude Code v2.1.218 gilt bei `context: fork` standardmäßig `background: true` — der Subagent läuft losgelöst, und sein Ergebnis kommt nicht in dem Turn zurück, der ihn aufgerufen hat. Jeder Fork-Skill, der vor dieser Version geschrieben wurde, hat sein Verhalten geändert, ohne dass sich eine einzige Zeile geändert hätte. ALBAs `/research` und `/reflect` setzen `background: false` explizit, denn wer eine Frage stellt, erwartet die Antwort jetzt. Genau deshalb liegt ALBAs Minimum bei v2.1.218.

Vollständige Frontmatter-Referenz: [`templates/skills/SKILL-TEMPLATE.md`](templates/skills/SKILL-TEMPLATE.md).

### Speichersystem

```
HOT  (jede Sitzung)      →  memory/state/dashboard.md, todo.md
WARM (bei Erkenntnissen)  →  memory/knowledge/learnings.md, errors.md, preferences.md
COLD (pro Projekt)        →  memory/projects/[name]/context.md
LOGS (automatisch)        →  memory/daily/YYYY-MM-DD.md
```

### Hook-System

Hooks sind Bash-Skripte, die durch Claude Code Events ausgelöst und in `.claude/settings.json` verdrahtet werden. Sie laufen automatisch — kein manueller Aufruf nötig. Claude Code stellt 30 Hook-Events bereit; ALBA nutzt neun davon und dokumentiert alle in [`templates/hooks/README-hooks.md`](templates/hooks/README-hooks.md).

Hooks scheitern lautlos. Ein falsch geschriebener Event-Name, ein fehlendes inneres `hooks`-Array, ein relativer Pfad, der bricht, sobald Sie eine Sitzung in einem Unterverzeichnis öffnen — nichts davon erzeugt einen Fehler. Die Funktion passiert einfach nie. Genau dafür ist `tools/doctor.sh` da.

### Subagents

`.claude/agents/` enthält Subagent-Definitionen — benannte Rollen, an die Claude delegieren kann. ALBA liefert genau eine mit, `planner.md`, und hält sie bewusst schlank. Für Frontmatter-Felder, die vorgeben, die Tools eines Agents einzuschränken, ließ sich nicht belegen, dass sie tatsächlich etwas erzwingen; die Einschränkung steht deshalb als Anweisung da, statt als Konfiguration aufzutreten. Wenn Sie eine harte Grenze brauchen, gehört sie in `permissions.deny`: Deny-Regeln werden ausgewertet, unabhängig davon, was ein Agent oder Hook verlangt.

### Single Source of Truth

`templates/` ist die einzige Stelle, die Sie bearbeiten. Der `.claude/`-Baum in jeder Beispielrolle wird daraus generiert:

```bash
tools/sync-examples.sh          # regenerate examples/ from templates/
tools/sync-examples.sh --check  # report drift without changing anything
tools/doctor.sh                 # full health check, run before committing
```

Rollenspezifische Dateien — `CLAUDE.md`, `README.md`, `memory/` — werden nie überschrieben; genau dafür ist ein Beispiel da. Vor v2.0.0 lag jedes Hook-Skript an sechs Stellen gleichzeitig, und die Beispieldokumentation war ein ganzes Release hinter ihre Templates zurückgefallen.

### Kompatibilität

- **Claude Code Auto-Memory**: koexistiert ohne Konflikte ([Details](.claude/docs/memory-compatibility.md))
- **`/loop` Scheduling**: sitzungsbezogene periodische Aufgaben ([Details](.claude/docs/loop-integration.md))
- **MCP-Server**: optional (Trello, Gmail, Calendar, Exa, Firecrawl) — ALBA funktioniert eigenständig

---

## ALBA erweitern

Nach dem Setup können Sie jederzeit Funktionen hinzufügen:

```
/extend
```

Oder fragen Sie einfach direkt:
- "Ich möchte einen Skill zum Entwerfen von E-Mails"
- "Füge einen Hook hinzu, der am Sitzungsende automatisch committet"
- "Erstelle eine Rule für Code-Review-Standards"
- "Verbinde mein Trello-Board"

---

## Voraussetzungen

- **Claude Code v2.1.218 oder neuer.** Verifiziert gegen v2.1.220. [Installieren](https://docs.claude.com/en/docs/claude-code). Diese Untergrenze ist nicht willkürlich: `background` für geforkte Skills kam mit v2.1.218, und ohne dieses Feld liefern `/research` und `/reflect` ihre Antworten an einen Background-Task statt an Sie.
- **Git**
- **jq** — wird von den Hooks zum Parsen des Event-JSON genutzt. Jeder Hook fällt ohne jq auf einen grep-Fallback zurück, aber die Installation ist ein einziger Befehl.

MCP-Server sind optionale Erweiterungen — ALBA funktioniert vollständig eigenständig.

Sie aktualisieren Claude Code? Führen Sie `tools/doctor.sh` aus. Es prüft genau die Dinge, die über Versionen hinweg lautlos brechen: Hook-Event-Namen, Settings-Schema, tote Skript-Pfade.

---

## Windows-Setup

ALBAs Hooks sind Bash-Skripte. Claude Code läuft nativ auf Windows (kein WSL erforderlich) und leitet Bash-Befehle automatisch durch Git Bash — aber Sie brauchen ein paar Voraussetzungen:

```powershell
# 1. Git for Windows installieren (enthält Git Bash)
winget install --id Git.Git -e

# 2. jq installieren (von Hooks für JSON-Parsing genutzt)
winget install --id jqlang.jq -e

# 3. Claude Code installieren
irm https://claude.ai/install.ps1 | iex
```

Danach ALBA klonen und im Repo-Wurzelverzeichnis `claude` ausführen — Git Bash erledigt den Rest.

**Warum das funktioniert:** ALBAs `.gitattributes`-Datei erzwingt LF-Zeilenenden für `*.sh`-Dateien und verhindert so den `bad interpreter: bash\r`-Fehler, der unter Windows' standardmäßiger CRLF-Einstellung Bash-Skripte zerstört.

**Alternative:** WSL2 funktioniert ebenfalls (gleiche Installationsschritte innerhalb der Linux-Distribution). Verwenden Sie WSL2, wenn Sie eine vollständige Linux-Toolchain bevorzugen.

**Fehlerbehebung:** Wenn Hooks mit `command not found: jq` fehlschlagen, installieren Sie jq mit dem Befehl oben. Wenn Sie `bad interpreter` sehen, stammt Ihr Klon aus der Zeit vor `.gitattributes` — klonen Sie das Repo erneut.

---

## Mitwirken

Beiträge sind willkommen! Siehe [CONTRIBUTING.md](CONTRIBUTING.md).

**Besonders wertvolle Beiträge:**
- Beispiel-Konfigurationen für neue Rollen
- Eigene Skill-Templates
- Hook-Rezepte
- Integrationsleitfäden

Bearbeiten Sie `templates/`, niemals `examples/` — und führen Sie `tools/sync-examples.sh` sowie `tools/doctor.sh` aus, bevor Sie einen PR öffnen.

---

## Lizenz

MIT-Lizenz — siehe [LICENSE](LICENSE)

---

## Community

- [GitHub Issues](https://github.com/onurpolat05/alba/issues) — Fehlermeldungen und Feature-Anfragen
- [GitHub Discussions](https://github.com/onurpolat05/alba/discussions) — Fragen und Ideen

---

*ALBA — Konsistent. Eigenständig. Immer lernend.*

> Benannt nach der Katze Abla. *Alba* bedeutet im Lateinischen "Morgendämmerung" — ein neuer Anfang für Ihren KI-Workflow.

## Star History

<a href="https://star-history.com/#onurpolat05/ALBA&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=onurpolat05/ALBA&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=onurpolat05/ALBA&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=onurpolat05/ALBA&type=Date" />
 </picture>
</a>
