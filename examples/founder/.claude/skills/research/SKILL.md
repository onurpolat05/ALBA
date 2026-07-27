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

# /research - Web Research

Perform structured web research on any topic. Runs as a subagent (fork) to keep main context clean.

## Why `background: false`

`context: fork` alone is not enough. Since Claude Code v2.1.218, forked skills default to
`background: true` — they run detached and the result arrives as a later notification instead of
in the turn that invoked the skill. Research is a request for an answer *now*, so this skill pins
`background: false`: the fork still keeps its search noise out of the main context, but the
conversation waits for the report and hands it back inline.

If you copy this skill into a workflow where you genuinely want fire-and-forget research
(e.g. kicked off by a scheduled task), drop the `background: false` line.

**Requires Claude Code v2.1.218 or later.** On older versions the field is ignored and the skill
runs inline-blocking as it always did.

## Input

```
/research [topic]
/research [topic] deep
```

`$ARGUMENTS` carries the whole invocation; the trailing word `deep` selects deep mode.

- **Default (quick):** 3-5 sources, summary format
- **Deep:** 8-10 sources, full analysis with confidence ratings

## Process

### 1. Search Strategy

Use available tools with graceful fallback:

| Priority | Tool | Best For |
|----------|------|----------|
| 1st | `mcp__exa__web_search_exa` | Semantic search, finding relevant articles |
| 2nd | `mcp__firecrawl__firecrawl_search` | Search + scrape combined |
| 3rd | `WebSearch` (built-in) | Basic web search |
| 4th | `WebFetch` (built-in) | Fetch specific URLs |

**Fallback rule:** If an MCP tool is unavailable, skip it and use the next available. WebSearch + WebFetch are always available as baseline.

The Exa and Firecrawl entries in `allowed-tools` are there so the chain works for people who *do*
have those MCP servers connected. MCP servers are optional in ALBA — if you never install them,
those entries simply never match anything and the skill runs on the built-in tools.

### 2. Gather & Validate

- Search with 2-3 different query variations
- Cross-reference findings across sources
- Note conflicting information explicitly
- Prefer recent sources (< 1 year old)

### 3. Synthesize

Don't just concatenate sources. Analyze, compare, and draw conclusions.

## Output Format

### Quick Research

```markdown
## Research: [Topic]

### Summary
[2-3 sentences - the key takeaway]

### Key Findings
- [Finding 1] (Source: [name])
- [Finding 2] (Source: [name])
- [Finding 3] (Source: [name])

### Sources
1. [Title](url) - [one-line relevance note]
```

### Deep Research

```markdown
## Research: [Topic]

### Executive Summary
[2-3 sentences overview]

### Key Findings
- [Finding] *(Confidence: High - 3+ sources confirm)*
- [Finding] *(Confidence: Medium - 1-2 sources)*
- [Finding] *(Confidence: Low - single source, unverified)*

### Detailed Analysis

#### [Theme 1]
[Analysis with source references]

#### [Theme 2]
[Analysis with source references]

### Confidence Assessment
- **Overall:** [High/Medium/Low]
- **Gaps:** [What couldn't be found or verified]
- **Conflicts:** [Any contradictions between sources]

### Sources
1. [Title](url) - [relevance + reliability note]
2. ...
```

### 4. Save (Deep only)

For deep research, save output to `memory/research/[topic-slug].md`.
Create `memory/research/` directory if it doesn't exist.

## Rules

- Always cite sources with links
- Never fabricate or assume information
- State confidence levels honestly
- If a topic has no good sources, say so clearly
- Keep quick research under 30 lines
- Keep deep research under 100 lines
- Use the user's language for output (match CLAUDE.md language setting)
