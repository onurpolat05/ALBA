---
name: research
description: Web research with structured output using available search tools
context: fork
allowed-tools: [Read, Write, Glob, Grep, WebSearch, WebFetch]
---

# /research - Web Research

Perform structured web research on any topic. Runs as a subagent (fork) to keep main context clean.

## Input

```
/research [topic]
/research [topic] deep
```

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
