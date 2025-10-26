# How to Contribute

## About this File

This is the contribution guide for contributors (both human and AI) to this project.

## Workflow Documentation

This project uses an artifact-driven, multi-model development workflow.

**Key documents:**
- [Workflow/Workflow.md](Workflow/Workflow.md) - Complete workflow overview
- [Workflow/RoleCatalog.md](Workflow/RoleCatalog.md) - All available roles
- [Workflow/Ontology.md](Workflow/Ontology.md) - All artifact types
- [Workflow/LayoutAndState.md](Workflow/LayoutAndState.md) - File organization and state tracking

## For AI Agents

You will be told what role you should play, either explicitly or implicitly based on context.

**To take on a role:**
1. Read the corresponding role file from `Workflow/role-*.md`
2. Read any schema files it references from `Workflow/schema-*.md`
3. Read the relevant project documents (VISION.md, SCOPE.md, ROADMAP.md, SYSTEM_MAP.md, GUIDELINES.md)
4. Follow the instructions in the role file

**Common roles:**
- [vision-writing-helper](Workflow/role-vision-writing-helper.md) - Help create VISION.md
- [spec-writer](Workflow/role-spec-writer.md) - Write feature specifications
- [test-writer](Workflow/role-test-writer.md) - Write TDD test suites
- [implementer](Workflow/role-implementer.md) - Implement features
- [platform-lead](Workflow/role-platform-lead.md) - Maintain living documentation

See [Workflow/RoleCatalog.md](Workflow/RoleCatalog.md) for the complete list.

## For Human Contributors

### Understanding the Workflow

The workflow follows this general sequence:

1. **Strategic Planning**: Create VISION.md, SCOPE.md, ROADMAP.md
2. **Feature Specification**: Write specs, move through proposed → todo → doing → done
3. **Implementation**: Skeleton → Tests (RED) → Implementation (GREEN) → Review
4. **Maintenance**: Update living docs (SYSTEM_MAP.md, GUIDELINES.md) as needed

See [Workflow/Workflow.md](Workflow/Workflow.md) for details.

### Getting Started

Ask an AI agent to help you:

```
"Act as vision-writing-helper to help me create a VISION.md"
```

Then follow the workflow sequence to create SCOPE.md, ROADMAP.md, and your first feature.

---

## Project-Specific Contribution Guidelines

[Add project-specific information here as needed]

### Development Setup

[Add project-specific setup instructions]

### Coding Standards

See [GUIDELINES.md](GUIDELINES.md) for project-specific coding standards.

### Testing Requirements

See [GUIDELINES.md](GUIDELINES.md) for testing standards.
