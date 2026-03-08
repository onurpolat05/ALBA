# Research Skill - Reference Guide

> **Note:** This is a reference guide for understanding and customizing the research skill.
> The actual skill is at `.claude/skills/research/SKILL.md`.

## Purpose

Perform comprehensive web research on a topic using semantic search (Exa) and web scraping (Firecrawl).

## When to Use

Claude should use this skill when:
- User asks "research [topic]"
- User says "find information about [topic]"
- Keywords: "research", "find info", "learn about", "investigate"

## How It Works

1. Use Exa for semantic search (find relevant sources)
2. Use Firecrawl to scrape detailed content from top sources
3. Analyze and synthesize information using invoke_llm
4. Return structured summary with sources

## Input Requirements

| Input | Description | Required |
|-------|-------------|----------|
| topic | What to research | Yes |
| depth | "quick" or "deep" | No (default: quick) |
| sources_count | Number of sources | No (default: 5) |

## Output Format

Returns a markdown report with:
- Executive Summary
- Key Findings (bullet points)
- Detailed Insights (sections)
- Sources (links)

Example:
```markdown
## Research: AI Agent Frameworks

### Summary
[2-3 sentences overview]

### Key Findings
- Finding 1 (Confidence: High - multiple sources confirm)
- Finding 2 (Confidence: Medium - limited sources)

### Detailed Insights
[Sections with analysis]

### Confidence Assessment
- Overall: [High/Medium/Low]
- Gaps: [What couldn't be verified or found]
- Conflicting info: [Any contradictions between sources]

### Sources
- [Source 1](url)
- [Source 2](url)
```

## Configuration

### Required Settings
- At least one search MCP server configured (see options below)

### MCP Options (pick what you need)
| MCP Server | Purpose | Setup |
|-----------|---------|-------|
| Exa | Semantic search | `mcp__exa__web_search_exa` |
| Firecrawl | Web scraping, crawling | `mcp__firecrawl__firecrawl_scrape` |
| WebSearch (built-in) | Basic web search | No setup needed (Claude Code built-in) |
| WebFetch (built-in) | Fetch URL content | No setup needed (Claude Code built-in) |

### Optional Settings
- Default search depth (quick/deep)
- Max sources to fetch

## Usage Examples

### Example 1: Quick Research
```
User: "Research AI project management tools"
Claude: [Uses research skill]
Output: Structured report with 5 sources, key findings
```

### Example 2: Deep Dive
```
User: "Deep research on multi-agent systems, need 10+ sources"
Claude: [Uses research skill with depth=deep, sources=10]
Output: Comprehensive report with detailed analysis
```

## Dependencies

- **WebSearch / WebFetch** (built-in) - Basic search, no setup needed
- **Exa MCP** (optional) - Semantic search for higher quality results
- **Firecrawl MCP** (optional) - Full page scraping and site crawling

Without any MCP servers, the skill falls back to WebSearch + WebFetch (built-in Claude Code tools).

## Notes

- Exa is best for semantic "find articles about X" searches
- Firecrawl scrapes full page content (better than summaries)
- Combine both for comprehensive research
- Use invoke_llm to synthesize findings (don't just concatenate)
- Always cite sources with links

---

*ALBA v1.0*
