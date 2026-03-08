# ALBA - Product Requirements Document

**Version:** 1.0
**Date:** 2026-03-07
**Author:** Onur Polat
**Status:** Draft

---

## 1. Executive Summary

ALBA is an open-source personal AI agent starter kit for Claude Code. It transforms Claude Code from a developer tool into a **personal AI companion** that adapts to any role - developer, PM, designer, content creator, founder, or anyone who wants an organized, self-improving AI workflow.

**What ALBA does:**
- Interactive setup that builds a personalized agent in ~10 minutes
- Persistent memory system that learns and grows across sessions
- Extensible skills, hooks, and rules architecture
- Multi-agent support for complex workflows
- Self-improvement: automatically learns from errors and records insights

**What makes ALBA different:**
- **Role-agnostic:** Not just for developers - works for any profession
- **Cat-inspired design:** Routine-driven, independent, self-grooming (self-improving)
- **Full system, not just config:** Memory + Skills + Hooks + Agents + Rules
- **Collaborative setup:** Guides users through personalization, never assumes
- **Battle-tested:** Based on a real production system managing 15+ projects

---

## 2. Vision & Identity

### 2.1 Name

**ALBA** - derived from "Abla" (the cat mascot).

Multiple layers of meaning:
- **ABLA** -> **ALBA** (letter rearrangement from the cat's name)
- **Alba** = "dawn" in Latin/Italian/Spanish -> new beginning, fresh start
- **Abla** = "older sister" in Turkish -> nurturing, organized, reliable
- Short, memorable, works internationally

### 2.2 Mascot: Abla the Cat

The project mascot is Abla, a real cat. The cat photo will be converted to a cartoon/illustrated character for branding.

### 2.3 Cat Metaphor - Core Design Philosophy

Cats are creatures of **routine, independence, and self-care**. Every ALBA feature maps to a cat behavior:

| Cat Behavior | ALBA Feature | Description |
|-------------|-------------|-------------|
| **Routines** | Session lifecycle | `/start`, `/end` - consistent daily patterns |
| **Self-grooming** | Self-improvement | Auto-learns from errors, records insights |
| **Observing** | Monitoring & hooks | 8+ hooks watching events, proactive alerts |
| **Independence** | Autonomous agents | Multi-agent delegation, works without hand-holding |
| **Curiosity** | Research & exploration | Investigates topics, explores codebases |
| **Memory** | Persistent memory | Remembers every corner of your projects |
| **Landing on feet** | Error resilience | Learns from errors, never repeats mistakes |
| **9 lives** | Recovery patterns | Graceful degradation, multiple fallback strategies |
| **Territory** | Project tracking | Knows every active project, context-switches cleanly |
| **Purring** | Proactive suggestions | Gentle nudges - deadline reminders, agent suggestions |

### 2.4 Tagline Candidates

1. **"Your routine-driven AI companion"**
2. **"Consistent. Independent. Always watching."**
3. **"Build your personal AI agent in 10 minutes"**
4. **"The personal AI that learns your routines"**

### 2.5 Tone & Voice

- **Warm but professional** - like a reliable colleague, not a chatbot
- **Concise** - CLI environment, respect terminal space
- **Transparent** - always explains what it's doing and why
- **Collaborative** - guides, doesn't dictate

---

## 3. Problem Statement

### 3.1 Current Pain Points

**For Claude Code users:**
- Raw Claude Code has no memory across sessions
- No structured way to organize personal workflows
- CLAUDE.md is powerful but underdocumented - most users write 10 lines
- Hooks, skills, agents are game-changers but have a steep learning curve
- No starter template that goes beyond "developer assistant"

**For non-technical professionals:**
- AI assistants are either too simple (ChatGPT) or too technical (Claude Code)
- No bridge between terminal AI power and daily workflow management
- Personal productivity tools don't leverage AI properly
- Context is lost between sessions - every conversation starts from zero

### 3.2 Market Gap

| Category | Existing Solutions | Gap |
|---------|-------------------|-----|
| Developer AI | Cursor, Copilot, everything-claude-code | Developer-only, no personal assistant |
| AI Assistants | ChatGPT, Gemini, Claude.ai | No persistence, no customization |
| Personal Agents | OpenClaw, Leon AI | Complex setup, not Claude Code native |
| Executive AI | LangChain EA | Python/LangGraph, email-only, not extensible |
| CC Memory | claude-mem, claude-diary | Memory only, not full agent system |
| CC Config | centminmod, dotfiles | Config boilerplate, no agent intelligence |

**ALBA fills the gap:** A complete, Claude Code-native personal agent system that works for any role, not just developers.

---

## 4. Target Audience

### 4.1 Primary: Claude Code Power Users

- Already using Claude Code daily
- Want to level up with memory, skills, hooks
- Technical enough for CLI but want guided setup
- Roles: developers, DevOps, tech leads, solopreneurs

### 4.2 Secondary: Professionals Seeking AI Workflows

- PM, content creators, founders, freelancers
- Heard about Claude Code, need guidance
- Want AI-powered personal organization
- Roles: project managers, designers, content creators, consultants

### 4.3 Future (v2+): Non-Technical Users via Telegram

- Don't use terminal/CLI
- Want personal AI assistant on their phone
- Telegram as the primary interface
- Task management, reminders, information retrieval

### 4.4 User Personas

**Persona 1: "Dev Onur"** - Full-stack developer, 10+ active projects, wants organized AI workflow
- Pain: Context switching, losing track of tasks
- Need: Memory system, multi-project tracking, research skills
- Setup: Advanced, Standard/Custom

**Persona 2: "PM Sarah"** - Project manager, email overload, team coordination
- Pain: Too many tools, scattered information
- Need: Email triage, task tracking, meeting prep
- Setup: Intermediate, Standard

**Persona 3: "Creator Alex"** - Content creator, research-heavy, multiple platforms
- Pain: Research takes too long, content planning chaotic
- Need: Research skills, content calendar, social media automation
- Setup: Beginner/Intermediate, Minimal/Standard

**Persona 4: "Founder Elif"** - Startup founder, wears many hats
- Pain: Needs EA but can't afford one, decision overload
- Need: Executive assistant, prioritization, delegation
- Setup: Intermediate, Standard/Custom

---

## 5. Competitive Analysis

### 5.1 Direct Competitors (Claude Code Ecosystem)

| Project | Stars | Category | Strength | Weakness | ALBA Advantage |
|---------|-------|----------|----------|----------|----------------|
| everything-claude-code | 63.5K | Dev harness | 65+ skills, npm | Dev-only, complex | Role-agnostic, simpler setup |
| claude-mem | 33.2K | Memory plugin | Vector search, UI | Memory only | Full agent system |
| centminmod/cc-setup | 1.9K | Config template | Good memory bank | Static, no interactivity | Interactive setup, living system |
| claude-diary | 334 | Memory/reflection | /reflect pattern | Diary only | Complete agent with reflection |
| opagent-starter (current) | 3 | Starter kit | Good foundation | Outdated, incomplete | Complete rewrite as ALBA |

### 5.2 Indirect Competitors

| Project | Stars | Category | Why ALBA Wins |
|---------|-------|----------|---------------|
| OpenClaw | 250K+ | Multi-platform AI | CC-native, no security issues, focused |
| LangChain EA | 2.2K | Executive AI | No Python dependency, extensible |
| Leon AI | 17K | Personal assistant | CC-native, no standalone server needed |
| obsidian-claude-pkm | 1.2K | PKM + AI | Not locked to Obsidian |

### 5.3 What We Can Learn From Each

| Source | Pattern to Adopt |
|--------|-----------------|
| everything-claude-code | npm distribution (future), instinct-based learning |
| claude-diary | `/reflect` pattern - auto-derive rules from sessions |
| obsidian-pkm | Cascade goal system (vision -> daily) |
| claude-code-telegram | Webhook API, scheduler, cost tracking |
| OpenClaw | Skill registry / marketplace concept |
| LangChain EA | Triage logic (ignore/notify/respond), tone preferences |
| claude-mem | Vector search for memory, progressive disclosure MCP |

---

## 6. Product Architecture

### 6.1 System Overview

```
ALBA Agent System
|
|-- CLAUDE.md                    # Agent brain - identity, rules, references
|-- .claude/
|   |-- settings.json            # Permissions, hooks config
|   |-- docs/                    # System documentation (lazy-loaded)
|   |   |-- memory-system.md
|   |   |-- decision-protocol.md
|   |   |-- self-improvement.md
|   |   `-- extend-guide.md
|   |-- rules/                   # Behavioral rules (auto-loaded)
|   |   |-- behavioral.md
|   |   |-- security.md
|   |   `-- [custom].md
|   |-- skills/                  # Custom capabilities
|   |   |-- research/SKILL.md
|   |   |-- [custom]/SKILL.md
|   |   `-- ...
|   |-- hooks/                   # Automation scripts
|   |   |-- session-start.sh
|   |   |-- session-stop.sh
|   |   |-- error-logger.sh
|   |   |-- memory-check.sh
|   |   `-- agent-suggest.sh
|   `-- agents/                  # Custom agent definitions (optional)
|       |-- researcher.md
|       `-- [custom].md
|-- memory/
|   |-- state/                   # Current state (updated frequently)
|   |   |-- dashboard.md         # Daily overview
|   |   `-- todo.md              # Active tasks
|   |-- knowledge/               # Long-term knowledge (updated occasionally)
|   |   |-- learnings.md         # Auto-updated insights
|   |   |-- errors.md            # Auto-updated error solutions
|   |   `-- preferences.md       # User preferences
|   |-- projects/                # Per-project context
|   |   `-- [project]/
|   |       |-- context.md
|   |       `-- planning.md
|   `-- daily/                   # Session logs (auto-created)
|       `-- YYYY-MM-DD.md
`-- setup/                       # Setup system (can be removed after setup)
    |-- initial-setup.md
    `-- extend-system.md
```

### 6.2 Core Subsystems

#### 6.2.1 Memory System

Three-tier architecture:

| Tier | Folder | Update Frequency | Purpose |
|------|--------|-----------------|---------|
| **Hot** | `memory/state/` | Every session | Dashboard, active tasks, current focus |
| **Warm** | `memory/knowledge/` | Occasionally | Learnings, errors, preferences |
| **Cold** | `memory/projects/` | Per-project | Project context, planning docs |

**Key patterns:**
- **Progressive disclosure:** Never load all memory at once. Read what's needed.
- **Auto-update:** errors.md and learnings.md are maintained by ALBA automatically
- **Daily logs:** Auto-created session summaries in daily/
- **Archive pattern:** Completed projects move to projects/archive/

#### 6.2.2 Skills System (Skills 2.0)

Skills are Claude Code's capability extension mechanism.

**Frontmatter support (v2.1.71+):**
```yaml
---
name: research
description: Web research and summarization
context: fork          # Runs in subagent (protects main context)
agent: Explore         # Agent type when forked
allowed-tools: Read, Write, WebSearch, WebFetch
model: claude-sonnet-4-6  # Optional: skill-specific model
---
```

**Included skills (v1.0):**
| Skill | Purpose | Context |
|-------|---------|---------|
| `research` | Web research with multiple sources | fork |
| `start` | Begin session, load context, show priorities | inline |
| `end` | End session, update memory, summary | inline |
| `status` | Quick status overview | inline |
| `setup` | Initial interactive setup | inline |
| `extend` | Add new features interactively | inline |
| `reflect` | Cross-session pattern analysis | fork |

**Template skills (available as examples):**
| Skill | Purpose |
|-------|---------|
| `email-draft` | Email composition with tone control |
| `task-automation` | Trello/Notion task management |
| `content-creation` | Social media post generation |
| `competitor-analysis` | Market/competitor research |

#### 6.2.3 Hooks System

Hooks are automated responses to Claude Code events.

**Included hooks (v1.0):**

| Hook Event | Script | Purpose |
|------------|--------|---------|
| `SessionStart` | session-start.sh | Load context, show dashboard |
| `Stop` | memory-check.sh | Remind to save memory if long session |
| `PreToolUse` | bash-validator.sh | Block dangerous bash commands |
| `PostToolUse` | error-logger.sh | Log error patterns for learning |
| `UserPromptSubmit` | agent-suggest.sh | Keyword-based agent suggestions |
| `PreCompact` | pre-compact.sh | Preserve critical info before compaction |

**Template hooks (available as examples):**
| Hook | Purpose |
|------|---------|
| `prompt-injection-guard` | Detect prompt injection in tool outputs |
| `auto-commit` | Auto-commit on session end |
| `notification` | OS notification on idle |

#### 6.2.4 Rules System

Rules define behavioral guidelines, auto-loaded from `.claude/rules/`.

**Included rules (v1.0):**
| Rule File | Content |
|-----------|---------|
| `behavioral.md` | Decision protocol, communication style, self-improvement |
| `security.md` | Input validation, secrets protection, safe commands |

**Template rules:**
| Rule File | Content |
|-----------|---------|
| `code-standards.md` | Pre-commit checks, TypeScript/linting |
| `content-creation.md` | Tone, format, quality standards |
| `team-collaboration.md` | PR reviews, communication channels |

#### 6.2.5 Agent System (Optional/Advanced)

Custom agent definitions for delegation.

**Template agents (v1.0):**
| Agent | Role | Tools |
|-------|------|-------|
| `researcher` | Deep web research | Read, WebSearch, WebFetch, Write |
| `planner` | Task breakdown and planning | Read, Write, Glob, Grep |

**How it works:**
- Agents are `.md` files in `.claude/agents/` (project) or `~/.claude/agents/` (global)
- Each defines: role, capabilities, tools, constraints
- Spawned via Agent tool or recommended by `agent-suggest.sh` hook

#### 6.2.6 Progressive Disclosure Pattern

The CLAUDE.md uses a reference table instead of loading everything:

```markdown
## Progressive Disclosure

| Situation | Read |
|-----------|------|
| Session start | `memory/state/dashboard.md` |
| Before decisions | `.claude/docs/decision-protocol.md` |
| Using memory | `.claude/docs/memory-system.md` |
| Calling skills | `.claude/skills/[skill]/SKILL.md` |
| Error encountered | `memory/knowledge/errors.md` |
| Recording learnings | `.claude/docs/self-improvement.md` |
```

This keeps CLAUDE.md under 200 lines while the full system documentation lives in docs/.

---

## 7. Feature Specification v1.0

### 7.1 Core Features (Must Have)

| # | Feature | Source | Description |
|---|---------|--------|-------------|
| F1 | Interactive Setup | Current starter | 7-question discovery + auto structure creation |
| F2 | Memory System | Current + opAgent | 3-tier memory (state/knowledge/projects) with auto-update |
| F3 | CLAUDE.md Generator | Current + enhanced | Role-based, progressive disclosure, self-improvement |
| F4 | Skills 2.0 | NEW (from opAgent) | Frontmatter, context:fork, $ARGUMENTS, allowed-tools |
| F5 | Hooks (6 patterns) | NEW (from opAgent) | SessionStart, Stop, PreToolUse, PostToolUse, UserPromptSubmit, PreCompact |
| F6 | Rules System | NEW (from opAgent) | .claude/rules/ with behavioral + security |
| F7 | Progressive Disclosure | NEW (from opAgent) | Lazy-load reference table in CLAUDE.md |
| F8 | Self-Improvement | Current + enhanced | Auto errors.md + learnings.md + daily logs |
| F9 | /start, /end, /status | Current | Session lifecycle commands |
| F10 | /extend | Current | Interactive feature addition |
| F11 | /reflect | NEW (from claude-diary) | Cross-session pattern analysis -> rule derivation |
| F12 | Decision Protocol | Current | Ask vs Act guidelines |
| F13 | Research Skill | Current + enhanced | Multi-source web research (Exa + Firecrawl or WebSearch) |
| F14 | Examples (3 roles) | Enhanced | Developer, PM, Content Creator setups |

### 7.2 Enhanced Features (Should Have)

| # | Feature | Source | Description |
|---|---------|--------|-------------|
| F15 | Agent Templates | NEW (from opAgent) | researcher + planner agent definitions |
| F16 | Security Hooks | NEW (from backlog P0) | Prompt injection guard, bash validator |
| F17 | Skill Creator | NEW (from backlog P3-1) | Meta-skill for creating new skills consistently |
| F18 | Quality Gates | NEW (from VAMFI) | Confidence scoring on plans and research |
| F19 | Dashboard Template | NEW (from opAgent) | Daily overview with projects, tasks, calendar |
| F20 | MCP Integration Guide | Enhanced | Step-by-step for Trello, Gmail, Calendar, Exa, Firecrawl |

### 7.3 Template/Example Features (Nice to Have)

| # | Feature | Source | Description |
|---|---------|--------|-------------|
| F21 | Cascade Goal System | Inspired by obsidian-pkm | Vision -> yearly -> monthly -> weekly -> daily |
| F22 | Content Creation Skill | NEW | LinkedIn/X/blog post generation |
| F23 | Email Triage Skill | Inspired by LangChain EA | Categorize: ignore/notify/respond |
| F24 | Morning Brief Command | Inspired by kjenney | /morning with weather, calendar, priorities |

---

## 8. Distribution Strategy

### 8.1 v1.0: GitHub Template Repository

**Primary distribution method.**

**Setup flow:**
```
1. GitHub: "Use this template" -> creates user's own repo
2. Terminal: cd my-agent && claude
3. Claude Code: /setup
4. Interactive: Answer 7 questions
5. Done: Personalized ALBA agent ready
```

**GitHub Template Repository requirements:**
- Repository Settings -> "Template repository" checkbox
- Clean README with "Use this template" button
- No personal data in template (only placeholders)
- `.gitignore` properly configured
- LICENSE (MIT)

**Alternative for non-GitHub users:**
```bash
git clone https://github.com/onurpolat05/alba.git my-agent
cd my-agent
rm -rf .git && git init
claude
# /setup
```

### 8.2 v1.1: npx create-alba (Future)

Interactive CLI scaffolding via npm. Deferred to post-v1.

### 8.3 v2.0: Telegram Bot (Future)

See Section 10 for detailed plan.

---

## 9. Roadmap

### Phase 1: ALBA v1.0 - "First Light" (Target: 2 weeks)

**Rebrand + Core System**

| Task | Priority | Effort |
|------|----------|--------|
| Rename opagent-starter -> alba | P0 | Low |
| New README with ALBA branding + cat mascot | P0 | Medium |
| Update CLAUDE.md template (progressive disclosure, skills 2.0) | P0 | Medium |
| Add hooks system (6 hooks) | P0 | Medium |
| Add rules system (behavioral + security) | P0 | Low |
| Update memory system templates | P1 | Low |
| Add /reflect skill | P1 | Medium |
| Add 3 example setups (dev, PM, creator) | P1 | High |
| Add agent templates (researcher, planner) | P1 | Low |
| Add skill creator meta-skill | P2 | Medium |
| Security hooks (prompt injection, bash validator) | P2 | Low |
| GitHub Template Repository setup | P0 | Low |
| Publish + announce | P0 | Low |

### Phase 2: ALBA v1.1 - "Sunrise" (Target: +4 weeks)

**Community + Polish**

| Task | Priority |
|------|----------|
| npx create-alba CLI | P1 |
| Community skill library (alba-skills repo) | P1 |
| Video tutorial (setup walkthrough) | P1 |
| Discord community | P2 |
| 5+ example setups from community | P2 |
| Cascade goal system template | P2 |
| MCP integration wizard | P2 |
| Quality gates + eval loops | P2 |

### Phase 3: ALBA v2.0 - "Full Dawn" (Target: +8 weeks)

**Telegram + Mobile**

| Task | Priority |
|------|----------|
| Telegram bot core (see Section 10) | P0 |
| Mobile-first commands (/status, /task, /remind) | P0 |
| Push notifications (deadlines, daily brief) | P1 |
| Voice message support | P2 |
| Photo/document handling | P2 |
| Multi-user support | P3 |

---

## 10. Telegram Integration Plan

### 10.1 Architecture

```
User (Telegram) <-> ALBA Telegram Bot <-> Claude Agent SDK <-> ALBA System
                                              |
                                         Memory System
                                         (shared with CLI)
```

### 10.2 Technical Stack

| Component | Technology | Why |
|-----------|-----------|-----|
| Bot framework | Python (python-telegram-bot) or TypeScript (telegraf) | Mature, well-documented |
| AI backend | Claude Agent SDK (@anthropic-ai/claude-agent-sdk) | Native Claude integration |
| Persistence | SQLite + file-based memory | Shared with CLI ALBA |
| Hosting | Self-hosted (Hetzner/Coolify) or serverless | User's infrastructure |
| Scheduler | node-cron or APScheduler | Daily briefs, reminders |

### 10.3 Telegram Commands (v2.0)

| Command | Description |
|---------|-------------|
| `/start` | Initialize bot, link to ALBA system |
| `/status` | Quick status from dashboard.md |
| `/task [text]` | Add task to todo.md |
| `/tasks` | List active tasks |
| `/remind [time] [text]` | Set reminder |
| `/brief` | Today's briefing (calendar + tasks + priorities) |
| `/research [topic]` | Quick research (triggers research skill) |
| `/note [text]` | Quick note to daily log |

### 10.4 Proactive Features

- **Morning brief:** Auto-send daily at configured time
- **Deadline alerts:** Remind before due dates
- **Session summary:** After CLI session ends, send summary to Telegram
- **Task completion:** Notify when background agents finish

### 10.5 Key Design Decisions

- **Shared memory:** Telegram bot reads/writes same memory/ folder as CLI
- **Not a replacement:** Telegram is a mobile companion, CLI is the power tool
- **Cost control:** Per-user token limits, rate limiting
- **Privacy:** Self-hosted, no data leaves user's infrastructure

---

## 11. Community & Growth Strategy

### 11.1 Launch Plan

**Week 1: Soft Launch**
- Publish GitHub Template Repository
- Post on: Claude Code Discord, r/ClaudeAI, HackerNews (Show HN)
- Tweet/LinkedIn post with Abla cat mascot

**Week 2-4: Community Building**
- Respond to issues/discussions
- Feature community setups in README
- Create Discord server (if traction)

**Month 2+: Content**
- Blog post: "How I built a personal AI agent with Claude Code"
- Video tutorial: Setup walkthrough
- Guest posts on AI/productivity blogs

### 11.2 Growth Metrics

| Metric | Target (3 months) |
|--------|-------------------|
| GitHub stars | 500+ |
| Template uses | 100+ |
| Community examples | 10+ |
| Discord members | 50+ |
| Contributors | 5+ |

### 11.3 Community Contributions

**What we want from community:**
- Example setups for different roles
- Custom skill templates
- Hook recipes
- Integration guides (for various MCP tools)
- Translations (README, setup flow)
- Bug reports and feature requests

---

## 12. Technical Decisions

### 12.1 Why Not a Framework?

ALBA is a **starter template**, not a framework. Key differences:

| Aspect | Framework | ALBA (Template) |
|--------|-----------|----------------|
| Dependency | Must import/install | Copy and own |
| Updates | Version locked | User controls |
| Flexibility | Constrained by API | Full freedom |
| Learning curve | Learn the framework | Learn the patterns |
| Maintenance | Framework team | User (or community) |

Users **own their ALBA** after setup. No dependency, no lock-in.

### 12.2 Why File-Based Memory?

| Alternative | Why Not |
|-------------|---------|
| SQLite | Overkill for most users, harder to inspect/edit |
| Vector DB | Requires embedding service, complex setup |
| Cloud storage | Privacy concerns, requires internet |
| **Markdown files** | **Human-readable, git-trackable, zero dependencies** |

Future consideration: Optional vector search layer (like claude-mem) as an extension.

### 12.3 Claude Code Version Requirements

ALBA v1.0 targets Claude Code **v2.1.50+** with full feature support in **v2.1.71+**.

| Feature | Min Version |
|---------|------------|
| Skills (basic) | v2.1.0+ |
| Skills 2.0 (frontmatter) | v2.1.50+ |
| context: fork | v2.1.50+ |
| $ARGUMENTS | v2.1.71+ |
| !`command` preprocessing | v2.1.71+ |
| Hooks (all types) | v2.1.50+ |
| Auto-memory | v2.1.50+ |
| Agents | v2.1.50+ |

---

## 13. Success Criteria

### 13.1 v1.0 Launch

- [ ] Interactive setup works end-to-end (clone -> /setup -> working agent)
- [ ] 3 example setups (developer, PM, content creator)
- [ ] Memory system functional (state, knowledge, projects, daily)
- [ ] 6 hooks operational
- [ ] /start, /end, /status, /reflect commands working
- [ ] Research skill functional
- [ ] README compelling with clear value proposition
- [ ] GitHub Template Repository configured
- [ ] MIT License

### 13.2 Quality Bar

- Setup completes in under 10 minutes
- No Claude Code errors during normal operation
- Memory persists correctly across sessions
- A non-developer (PM/creator) can complete setup successfully
- "Would a senior engineer approve this system?" -> Yes

---

## 14. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Claude Code API changes break hooks/skills | High | Pin minimum version, document compatibility |
| Users overwhelmed by complexity | Medium | Progressive complexity: minimal -> standard -> advanced |
| Memory files grow too large | Medium | Archive pattern, daily log rotation |
| Security: prompt injection via memory files | High | Prompt injection guard hook (P0 from backlog) |
| Low adoption / no traction | Medium | Strong branding (cat!), community engagement, Show HN |
| Telegram bot maintenance burden | Medium | Deferred to v2.0, assess community demand first |

---

## 15. Decisions Log

| # | Question | Decision | Date |
|---|----------|----------|------|
| 1 | Repo name | `alba` (github.com/onurpolat05/alba) | 2026-03-07 |
| 2 | Default language | English-first, TR optional | 2026-03-07 |
| 3 | MCP dependencies | Standalone, MCP optional (guide + templates provided) | 2026-03-07 |
| 4 | Distribution | GitHub Template Repository (v1), npx (v1.1), Telegram (v2) | 2026-03-07 |
| 5 | Monetization | Full open source (MIT) | 2026-03-07 |
| 6 | PRD location | In starter repo (docs/PRD.md) | 2026-03-07 |

### Open Questions

1. **Cat character style:** What illustration style for Abla? (minimalist line art, pixel art, kawaii, realistic cartoon?)
2. **Auto-memory vs manual:** Should ALBA use Claude Code's built-in auto-memory, manual memory system, or both?

---

## Appendix A: Migration from opagent-starter

| Current File | ALBA Equivalent | Change |
|-------------|----------------|--------|
| templates/claude/CLAUDE.md.template | templates/claude/CLAUDE.md.template | Major rewrite: progressive disclosure, skills 2.0 |
| setup/initial-setup.md | setup/initial-setup.md | Update: new features, better flow |
| setup/extend-system.md | setup/extend-system.md | Update: skills 2.0, hooks, agents |
| templates/INDEX.md | templates/INDEX.md | Update: new templates |
| templates/hooks/ (2 files) | templates/hooks/ (6+ files) | Major expansion |
| templates/skills/ (3 files) | templates/skills/ (7+ files) | Major expansion |
| templates/memory/ | templates/memory/ | Add dashboard, enhance templates |
| examples/software-engineer/ | examples/developer/ | Update + add 2 more |
| README.md | README.md | Complete rewrite: ALBA branding |
| CONTRIBUTING.md | CONTRIBUTING.md | Update: new contribution types |
| - | .claude/rules/ | NEW: behavioral + security rules |
| - | .claude/agents/ | NEW: agent templates |
| - | docs/ | NEW: PRD, ROADMAP, BRANDING |
| - | templates/agents/ | NEW: agent definition templates |

## Appendix B: Features from Optimization Backlog

These items from `opAgent/memory/knowledge/opagent-optimization-backlog.md` will be included in ALBA:

| Backlog Item | ALBA Feature | Priority |
|-------------|-------------|----------|
| P0-1: Prompt injection hook | Template hook + guide | v1.0 |
| P0-2: Dippy AST bash validator | Template hook + guide | v1.0 |
| P3-1: Skill creator meta-skill | Included skill | v1.0 |
| P3-2: Skill metadata frontmatter | Default in all skill templates | v1.0 |
| P3-3: Skill eval/quality loop | Pattern in research + content skills | v1.1 |
| P3-4: claude-rules-doctor | Documented as tool | v1.1 |
| P3-10: Statusline | Documented as optional enhancement | v1.1 |
| P2-2: Planner confidence score | Built into planner agent template | v1.0 |
| P2-3: UserPromptSubmit agent suggest | Included hook | v1.0 |

## Appendix C: Competitor Deep-Dive References

Full research data available in:
- Researcher agent output: `claude-code-personal-agent-landscape-2026.md`
- Market data: AI Agent market $7.84B (2025) -> $52.62B (2030), CAGR 46.3%

---

*Last updated: 2026-03-07*
*Author: Onur Polat*
*Project: ALBA (formerly opAgent Starter)*
