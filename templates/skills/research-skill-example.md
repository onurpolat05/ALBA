# Research Skill Example

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
- Finding 1
- Finding 2

### Detailed Insights
[Sections with analysis]

### Sources
- [Source 1](url)
- [Source 2](url)
```

## Configuration

### Required Settings
- Rube MCP must be configured
- Exa and Firecrawl access

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

- **Rube MCP** - For Exa and Firecrawl access
- **RUBE_SEARCH_TOOLS** - Find Exa and Firecrawl tools
- **RUBE_MULTI_EXECUTE_TOOL** - Execute searches
- **RUBE_REMOTE_WORKBENCH** - For data analysis (if large datasets)

## Notes

- Exa is best for semantic "find articles about X" searches
- Firecrawl scrapes full page content (better than summaries)
- Combine both for comprehensive research
- Use invoke_llm to synthesize findings (don't just concatenate)
- Always cite sources with links

---

Created: 2025-12-29
