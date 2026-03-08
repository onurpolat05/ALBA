---
name: research
description: Web research for technical topics, libraries, and best practices
context: fork
allowed-tools: Read, Write, WebSearch, WebFetch
---

# Research Skill

Perform web research on technical topics using available search tools.

## When to Use

- "Research [topic]"
- "Find information about [library/tool]"
- "Compare [X] vs [Y]"
- Technical deep-dives, library evaluations

## Process

1. Clarify the research question
2. Search from multiple angles (at least 3 queries)
3. Fetch and analyze top sources
4. Cross-reference findings
5. Return structured report

## Output Format

```markdown
## Research: [Topic]

### Summary
[2-3 sentence overview]

### Key Findings
- Finding 1
- Finding 2
- Finding 3

### Details
[Organized by subtopic]

### Sources
- [Source 1](url)
- [Source 2](url)

### Confidence
[High/Medium/Low] - [reasoning]
```

## Tools

- **WebSearch** (built-in) - Primary search
- **WebFetch** (built-in) - Fetch page content for deeper analysis
- **Exa MCP** (optional) - Semantic search for higher quality
- **Firecrawl MCP** (optional) - Full page scraping

Works without MCP servers using built-in tools.
