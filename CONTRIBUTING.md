# How to Work in this Project

## About this File

This is the file at which contributor's reading converges after starting at agent-specific files like CLAUDE.md, GEMINI.md, ...

## Information for Everyone

Please read [README.md](README.md) to learn what the project is about.

This file is specifically for contributors to the project whereas README.md is for everyone including people just browsing the repo and people thinking of using the project.
To avoid duplication, this file won't contain information that you would get to via README.md.

## Information for Contributors

Like the associated concrete projects, this meta-project is a multi-model project.
Each model or model-interface combination will or should have read its own, model-specific instruction file before reading this file.
If you are a model reading this that is participating in the project and you haven't already read an entry point file specific to you and your current interface, please report that to the user.

This is **very important**: Because of the similarities between this meta-project and the associated concrete projects, all participants must take great care in word and phrase choice to properly distinguish the levels.

## Meta-Project Structure

When making changes to this repository, please read [docs/MetaProjectStructure.md](docs/MetaProjectStructure.md) first.
This document explains why certain files must remain at the root and the dual nature of this repository.

**Key principle:** This repository is both:
1. A project that will be worked on by AI agents (needs entry points at root)
2. A workflow definition for other projects (provides templates)

Many files exist in both locations for these distinct purposes.

## Planning and Progress

See [docs/PLAN.md](docs/PLAN.md) for:
- Current status and recently completed work
- Next actions (what to work on next)
- Email integration implementation plan
- Backlog of other tasks

This is the single source of truth for tracking progress and choosing what to work on.

## Time Estimates

**Do not provide time estimates for tasks or projects.**

AI agents should avoid estimating how long tasks will take. Reasons:
- Pre-AI development timelines are not applicable to AI-augmented workflows
- Agent estimates are often off by orders of magnitude
- Estimates add noise without providing value
- Focus instead on dependencies, sequence, and scope

When planning work, describe:
- What needs to be done
- What depends on what
- What can be done in parallel
- Clear completion criteria

But do not estimate hours, days, or weeks for completion.