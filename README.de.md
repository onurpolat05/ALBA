<p align="center">
  <img src="assets/banner.png" alt="ALBA – Ihr routinebasierter KI-Begleiter" width="100%">
</p>

<p align="center">
  <a href="README.md">English</a> | <a href="README.tr.md">Türkçe</a> | <b>Deutsch</b>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <a href="https://docs.anthropic.com/en/docs/claude-code"><img src="https://img.shields.io/badge/Claude%20Code-v2.1.71+-purple.svg" alt="Claude Code"></a>
  <a href="https://github.com/onurpolat05/ALBA/stargazers"><img src="https://img.shields.io/github/stars/onurpolat05/ALBA?style=social" alt="Stars"></a>
</p>

---

ALBA verwandelt Claude Code in einen **persönlichen KI-Agenten**, der sich Ihre Prioritäten merkt, aus Ihren Fehlern lernt und sich an Ihren Arbeitsablauf anpasst — egal ob Sie Entwickler, Projektmanager, Forscher, Gründer oder Content Creator sind.

**10 Minuten interaktives Setup. Keine Abhängigkeiten. Reines Markdown.**

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
│   ├── hooks/                    # 6 automatisierte Event-Handler
│   ├── rules/                    # Verhaltensrichtlinien (automatisch geladen)
│   ├── docs/                     # Referenzdokumentation (lazy-loaded)
│   └── settings.json             # Hook-Konfiguration
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
| `/setup` | Interaktives Ersteinrichtung |

### 6 automatisierte Hooks

| Ereignis | Was passiert |
|----------|-------------|
| Sitzung startet | Dashboard wird geladen, Prioritäten angezeigt |
| Gefährlicher Befehl | Wird vor der Ausführung blockiert |
| Bash-Fehler | Automatisch für Mustererkennung protokolliert |
| Sitzung endet | Erinnerung, den Zustand zu speichern |
| Sie geben einen Prompt ein | Relevante Skills werden vorgeschlagen |
| Context Compacting | Kritische Informationen bleiben erhalten |

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
  /loop 30m /status         # Periodische Erinnerungen (Claude Code v2.1.71+)
```

---

## Vergleich

| Funktion | Claude Code pur | Andere Starter | ALBA |
|----------|----------------|----------------|------|
| Sitzungsübergreifender Speicher | Keiner | Teilweise (nur Speicher) | 3-Schichten (State/Knowledge/Projects) |
| Setup-Erfahrung | Manuelle Konfiguration | Copy-Paste | Interaktiver Assistent (7 Fragen) |
| Rollenunterstützung | Generisch | Nur Entwickler | Jede Rolle (5 Beispiele enthalten) |
| Selbstverbesserung | Nein | Nein | Automatische Fehler- und Erkenntniserfassung |
| Hooks | Manuelles Setup | Einige Templates | 6 Hooks, automatisch konfiguriert |
| Skills | Keine integrierten | Variiert | 9 integrierte, erweiterbar |
| Kontexteffizienz | N/A | N/A | Progressive Disclosure (< 200 Zeilen) |
| `/loop`-Unterstützung | N/A | N/A | Dokumentierte Integration |

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

### Skills 2.0

Skills verwenden YAML-Frontmatter mit expliziten Metadaten:

```yaml
---
name: research
description: Web research with structured output
context: fork          # runs as subagent (doesn't bloat main context)
allowed-tools: [Read, Write, WebSearch, WebFetch]
---
```

`context: fork` = aufwändige Aufgaben laufen als Subagents. `context: inline` = schnelle Aufgaben in der Hauptkonversation.

### Speichersystem

```
HOT  (jede Sitzung)      →  memory/state/dashboard.md, todo.md
WARM (bei Erkenntnissen)  →  memory/knowledge/learnings.md, errors.md, preferences.md
COLD (pro Projekt)        →  memory/projects/[name]/context.md
LOGS (automatisch)        →  memory/daily/YYYY-MM-DD.md
```

### Hook-System

Hooks sind Bash-Skripte, die durch Claude Code Events ausgelöst und in `.claude/settings.json` konfiguriert werden. Sie laufen automatisch — kein manueller Aufruf nötig.

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

- **Claude Code** v2.1.50+ ([Installieren](https://docs.anthropic.com/en/docs/claude-code))
- **Git**

MCP-Server sind optionale Erweiterungen — ALBA funktioniert vollständig eigenständig.

---

## Mitwirken

Beiträge sind willkommen! Siehe [CONTRIBUTING.md](CONTRIBUTING.md).

**Besonders wertvolle Beiträge:**
- Beispiel-Konfigurationen für neue Rollen
- Eigene Skill-Templates
- Hook-Rezepte
- Integrationsleitfäden

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
