---
name: research
description: Web research, information gathering, and summarization. Uses Exa + Firecrawl via Rube MCP.
allowed-tools: Read, Write, mcp__rube__*
---

# Research Skill

Web research and information gathering using Rube MCP with Exa + Firecrawl.

## When to Use

- User asks to "research", "find", "investigate" something
- Information gathering is needed on a topic
- Competitor/market analysis
- Technical documentation search

## Tools (via Rube MCP)

| Tool | Purpose | When to Use |
|------|---------|-------------|
| **Exa** | Semantic search | Topic-based search, "best X", "how to" |
| **Firecrawl Search** | Web search | General search, news |
| **Firecrawl Scrape** | Page content | Get specific URL content |
| **Firecrawl Map** | Site mapping | Find all pages on a site |

## Workflow

```
1. Get research topic from user
2. Determine search strategy:
   - General info → Exa semantic search
   - Current news → Firecrawl search
   - Specific site → Firecrawl scrape/map
3. Run searches (parallel if possible)
4. Filter results, select important ones
5. Extract key points (bullet points)
6. List sources
7. Present to user
```

## Output Format

```markdown
## [Topic] Research Results

### Summary
- Key finding 1
- Key finding 2
- Key finding 3

### Details
[Important information, paragraphs or lists]

### Sources
1. [Title](URL) - brief description
2. [Title](URL) - brief description

### Next Steps (optional)
- Suggestion 1
- Suggestion 2
```

## Search Strategies

### General Topic Research
```
1. Exa semantic search: "[topic] what is how it works"
2. Firecrawl search: "[topic] 2025"
3. Scrape top 3-5 results
4. Summarize
```

### Competitor/Market Analysis
```
1. Exa: "[industry] best tools 2025"
2. Firecrawl: "[competitor name] review"
3. Extract feature list for each competitor
4. Create comparison table
```

### Technical Documentation
```
1. Firecrawl search: "[technology] documentation"
2. Find official doc site
3. Firecrawl map to list pages
4. Scrape relevant pages
```

### News/Current Information
```
1. Firecrawl search: "[topic] news 2025"
2. Filter to last week's articles
3. Summarize
```

## Usage Examples

**Example 1: General Research**
```
User: "Research n8n alternatives"

Claude:
1. Exa search: "n8n alternatives workflow automation 2025"
2. Firecrawl search: "best n8n alternatives"
3. Scrape top 5 results
4. Create comparison table
```

**Example 2: Specific Site**
```
User: "Get Anthropic's latest blog posts"

Claude:
1. Firecrawl map: anthropic.com/blog
2. Scrape last 5 posts
3. Summarize each
```

**Example 3: Deep Research**
```
User: "Do detailed research on AI agent architectures"

Claude:
1. Spawn Task agent (background)
2. Multiple search queries in parallel
3. Collect 10+ sources
4. Create comprehensive report
5. Save to memory/projects/[topic]/
```

## Rules

1. **Always cite sources** - No information without URLs
2. **Freshness matters** - Prefer 2024-2025 results
3. **Summary first** - Details on request
4. **Work in parallel** - Run searches simultaneously when possible
5. **Save important research** - Store in memory/projects/

## Deep Research (Agent Mode)

For comprehensive research, use Task agent:

```
Spawn Task agent:
- subagent_type: "Explore" or "general-purpose"
- Prompt: Detailed research instructions
- Save result to memory
```

User should use words like "detailed", "comprehensive", "deep" to trigger this mode.

---

*Last updated: 2025-01-09*
