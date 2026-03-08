# Quality Gates

Every plan, research output, and analysis should include confidence scoring.

## Confidence Levels

| Level | Meaning | When to Use |
|-------|---------|-------------|
| **High** | Strong evidence, multiple confirmations | 3+ reliable sources agree, tested approach, proven pattern |
| **Medium** | Reasonable evidence, some uncertainty | 1-2 sources, untested but logical, partial confirmation |
| **Low** | Limited evidence, significant uncertainty | Single source, speculation, edge case, conflicting data |

## Where to Apply

### Plans (Planner Agent)
```
**Confidence:** [Level] - [reasoning]
```
Include per-step risk assessment and overall plan confidence.

### Research (Research Skill)
```
### Confidence Assessment
- Overall: [Level]
- Gaps: [what couldn't be found]
- Conflicting info: [contradictions]
```
Include per-finding confidence when sources vary in reliability.

### Analysis (/reflect)
```
## Recurring Patterns
1. [Pattern]: Confidence [Level] - observed [N] times
```
Pattern confidence increases with frequency of observation.

## Rules

1. **Never present Low confidence findings as facts** - flag uncertainty
2. **Always explain the reasoning** - "High because..." not just "High"
3. **Conflicting info = Medium at best** - unless one source clearly supersedes
4. **No sources = Low** - personal analysis without evidence is speculation
5. **User decides on Low confidence items** - present options, don't recommend
