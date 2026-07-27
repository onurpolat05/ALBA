# Research Skill - Reference Guide

> **Note:** This is a reference guide for understanding and customizing the research skill.
> The actual skill lives at `.claude/skills/research/SKILL.md`.
> For the full list of valid frontmatter fields, see `SKILL-TEMPLATE.md` in this directory.

## Purpose

Perform structured web research on a topic and return a cited, confidence-rated report — without
dragging every page of search noise into the main conversation's context window.

## Frontmatter, and why each line is there

```yaml
---
name: research
description: Structured web research with cited sources and confidence levels; runs in a forked subagent, quick (3-5 sources) or deep (8-10 sources, saved to memory/research/). Use when user says "research X", "look into X", "find information about X", "investigate X", "what's the state of X". Do NOT use for questions answerable from the codebase or memory files, for single-fact lookups (just answer, or fetch the one URL), or when the user already gave you the source to read.
context: fork
agent: general-purpose
background: false
effort: medium
argument-hint: <topic> [deep]
allowed-tools: [Read, Write, Glob, Grep, WebSearch, WebFetch, mcp__exa__web_search_exa, mcp__firecrawl__firecrawl_search, mcp__firecrawl__firecrawl_scrape]
---
```

| Line | Why |
|------|-----|
| `description` | Names the phrases a user actually types, then draws the boundary. Without the `Do NOT use` clause this skill fires on every trivial factual question and burns a subagent on something you could have answered directly |
| `context: fork` | Research reads a lot and discards most of it. The fork absorbs that; only the report comes back |
| `background: false` | **The important one — see below** |
| `agent: general-purpose` | The fork writes files (deep mode saves a report), so a read-only agent type won't do |
| `argument-hint` | The skill takes a topic and an optional `deep` flag; the hint surfaces that in autocomplete |
| `allowed-tools` | Built-in web tools plus the optional MCP search tools, so the fallback chain works for people who have them |

## The `background: false` line

Since Claude Code **v2.1.218**, `context: fork` defaults to `background: true`. A forked skill
detaches and reports back later instead of answering in the turn it was invoked.

For research that is the wrong default. Someone typing `/research vector databases` is waiting for
an answer, not scheduling a job. Without `background: false` they get an acknowledgement, the
conversation moves on, and the report arrives as a notification some time later.

So: keep the fork (for context isolation), disable the background (for a synchronous answer).

Flip it back to the default only if you're wiring research into something that genuinely runs
unattended — a scheduled sweep that writes to `memory/research/` for you to read tomorrow.

## When to Use

Claude should use this skill when:
- User asks "research [topic]" / "look into [topic]" / "investigate [topic]"
- User wants the current state of a field, a tool comparison, or a landscape scan
- The answer requires multiple sources cross-referenced against each other

And should **not** when:
- The answer is in the repo or in `memory/` — read the file
- It's a single fact or one known URL — answer directly, or fetch that URL
- The user already pasted the source

## How It Works

1. Search with 2-3 query variations, preferring semantic search when available
2. Fetch full page content for the most promising sources
3. Cross-reference: note where sources agree, and where they contradict each other
4. Synthesize into a report with explicit confidence levels — not a list of summaries
5. Deep mode only: save to `memory/research/[topic-slug].md`

## Input Requirements

| Input | Description | Required |
|-------|-------------|----------|
| topic | What to research | Yes |
| depth | `quick` (default) or `deep` | No |

## Output Format

Quick mode returns Summary → Key Findings (with sources) → Sources, under 30 lines.
Deep mode adds Detailed Analysis and a Confidence Assessment, under 100 lines.

```markdown
## Research: AI Agent Frameworks

### Summary
[2-3 sentences overview]

### Key Findings
- Finding 1 *(Confidence: High - 3+ sources confirm)*
- Finding 2 *(Confidence: Medium - 1-2 sources)*

### Confidence Assessment
- Overall: [High/Medium/Low]
- Gaps: [What couldn't be verified]
- Conflicts: [Contradictions between sources]

### Sources
1. [Title](url) - [relevance + reliability note]
```

## Configuration

### Required

Nothing. `WebSearch` and `WebFetch` are built into Claude Code and are the baseline.

### Optional MCP servers

| MCP Server | Adds | Tool name |
|-----------|------|-----------|
| Exa | Semantic search — better at "find articles arguing X" than keyword search | `mcp__exa__web_search_exa` |
| Firecrawl | Full-page scraping and site crawling, rather than search-result snippets | `mcp__firecrawl__firecrawl_search`, `mcp__firecrawl__firecrawl_scrape` |

These are listed in `allowed-tools` so the fallback chain works when they're connected. If you
never install them, those entries match nothing and the skill runs on the built-in tools. MCP is
optional in ALBA by design — the skill must work on a fresh clone with no servers configured.

## Notes

- Always cite sources with links; never fabricate a source
- State confidence honestly, including "I couldn't verify this"
- If a topic has no good sources, say so rather than padding the report
- Synthesize — a report that concatenates five summaries is worse than reading one of them

---

*ALBA v2.0.0*
