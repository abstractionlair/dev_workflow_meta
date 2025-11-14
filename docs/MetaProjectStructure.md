# Meta-Project File Structure

## Purpose of This Document

This document explains the file structure of the **meta-project** (this repository) and why certain files must remain at specific locations. This is critical guidance to prevent confusion when refactoring.

## Key Principle: Dual Purpose of Files

This meta-project serves **two distinct purposes**:

1. **It IS a project** that will be worked on by AI agents (Claude, Codex, Gemini, etc.)
2. **It DEFINES a workflow** that other projects will use as a git submodule

Because of this dual nature, some files exist in **two locations**:
- At the **root** for use by AI agents working on the meta-project itself
- In **templates/** as examples for concrete projects to copy

## Files That MUST Remain at Root

### Entry Point Files (AI Tool Discovery)

These files are the first files that AI tools read when starting work on a project. They MUST be at the root because:
- AI tools look for them at the root by convention
- This meta-project itself needs to be worked on by multiple AI models
- Each model/interface combination has different procedures for what to read

**Required at root:**
- `CLAUDE.md` - Entry point for Claude/Claude Code
- `AGENTS.md` - Routing file for other Anthropic agents
- `CODEX.md` - Entry point for OpenAI Codex
- `GEMINI.md` - Entry point for Google Gemini
- `OPENCODE.md` - Entry point for OpenCode TUI
- `.grok/GROK.md` - Entry point for Grok

### Support Files

These files support the AI agents working on the meta-project:

**Required at root:**
- `CONTRIBUTING.md` - Where all entry points converge; describes how to work in this project
- `GUIDELINES.md` - Development guidelines for the meta-project
- `SYSTEM_MAP.md` - System architecture for the meta-project
- `README.md` - Project overview and documentation hub

### Special Case: .gitignore

- `.gitignore` at root - For the meta-project's own ignored files
- `templates/.gitignore` - Template for concrete projects to copy

## Files in templates/

The `templates/` directory contains **copies** of files that concrete projects should use when they adopt this workflow as a submodule.

**Structure:**
```
templates/
├── entry-points/          # Copies of entry point files
│   ├── CLAUDE.md
│   ├── AGENTS.md
│   ├── CODEX.md
│   ├── GEMINI.md
│   └── OPENCODE.md
├── .grok/                 # Copy of .grok directory
│   ├── GROK.md
│   └── settings.json
├── CONTRIBUTING.md        # Template for concrete projects
├── GUIDELINES.md          # Template for concrete projects
├── SYSTEM_MAP.md          # Template for concrete projects
├── .gitignore             # Template for concrete projects
└── project-meta.config.json
```

## Why This Matters

### Anti-Pattern: Moving Entry Points to templates/

**WRONG:** Moving entry point files to `templates/` and removing them from root
- Breaks AI tool discovery for agents working on the meta-project
- Makes it impossible for Claude, Codex, Gemini, etc. to properly initialize when working on this repository
- Violates the DRY principle by forcing each model to implement custom discovery logic

**RIGHT:** Keep entry points at root AND in templates/
- AI tools can discover them when working on the meta-project
- Concrete projects can copy them from templates/
- Respects the dual nature of this repository

### The Meta-Project IS a Project

When refactoring, remember:
1. This meta-project will be worked on by AI agents
2. Those agents need their entry point files at the root
3. The fact that we also provide templates doesn't change this requirement
4. The templates are FOR OTHER PROJECTS, not for this one

## README.md Structure

The README.md should follow this order:

1. **## Why** - The motivation and problems being solved (personal experiences, observed pain points)
2. **## What/How** - What the project is and how it works
3. **## Using This Workflow** - How others can use it (Quick Start, structure)
4. **## This Repository Contains** - What's in the repo
5. **## For Contributors** - How to contribute to the meta-project
6. **## Coming Soon** - Future plans
7. **## License** - License information

**Rationale:** Starting with "Why" provides essential context about the problems this workflow solves. Understanding the motivation makes the "What/How" section more meaningful. The "Quick Start" comes after because users first need to understand why they would want to use this workflow.

## DRY Principle in Entry Points

The entry point files are carefully designed to respect the DRY principle:

1. Each model-specific file (CLAUDE.md, CODEX.md, etc.) contains ONLY model-specific information
2. All files converge at CONTRIBUTING.md for shared information
3. CONTRIBUTING.md points to README.md to avoid duplicating "what is this project" information

**Do not duplicate content across:**
- Model-specific entry points
- CONTRIBUTING.md
- README.md

Each should link to the next in the reading chain.

## When Making Structural Changes

Before moving or restructuring files, ask:

1. **Is this file needed by AI tools working on the meta-project?**
   - If yes, it must stay at root (may also be in templates/)

2. **Is this file only for concrete projects?**
   - If yes, it belongs only in templates/

3. **Does this file serve both purposes?**
   - If yes, it belongs at root AND in templates/

4. **Will this change break AI tool discovery?**
   - Test by checking if entry points can still be found at expected locations

## Examples of Correct Placement

### Files at Root Only
- `Workflow/` - Meta-project workflow documentation
- `bin/` - Meta-project utility scripts
- `docs/` - Meta-project documentation

### Files at Root AND templates/
- All entry point files (CLAUDE.md, AGENTS.md, etc.)
- CONTRIBUTING.md, GUIDELINES.md, SYSTEM_MAP.md
- .gitignore
- .grok/ directory

### Files in templates/ Only
- `project-meta.config.json` - Configuration for concrete projects
- `README.md.template` - Template for concrete project READMEs (different from meta-project README.md)

## Rationale: Why Both Locations?

You might wonder: "Why not use symlinks or have entry points only in templates/?"

**Symlinks don't solve the problem:**
- Symlinks would be confusing in git
- Concrete projects would end up with symlinks pointing to nowhere
- It adds complexity without benefit

**Having only templates/ doesn't work:**
- AI tools won't find entry points when working on the meta-project
- Forces custom discovery logic for each tool
- Violates the principle that the meta-project is itself a project

**Having both locations is correct:**
- Clear and explicit
- Works for both use cases
- No magic or indirection
- Easy to understand and maintain

## Summary

The meta-project has a dual nature: it's both a project itself and a definition of a workflow. This requires careful attention to file placement. When in doubt, remember: **AI tools need to find their entry points at the root.**

**Quick check before moving files:**
- Would an AI tool starting fresh on this repo be able to find its entry point?
- If no, the file must stay at root.
