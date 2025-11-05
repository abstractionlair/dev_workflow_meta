# AI-Augmented Software Development Workflow

## Why

Recent experiments of mine (circa October 2025) with Claude Code, OpenAI Codex, and other similar tools, have followed a similar pattern.
Excellent progress and results when starting a project but gradually degrading afterwards as the project grows.
Particular pain points included the following.
- Models "forgeting" big things like utility methods or layers that we'd already built. This led to reimplementing functionality we already had when adding new features. In more than one case, the reimplementing even recreated the same bugs as-in the initial implementation. This would happen over days.
- Models forgetting details. This was at smaller time scales and usually involved context filling and needing to be compacted. After the compaction a model would "remember" the general idea of what we were doing but lose details. E.g. it remembered we were writing an eval of something but forgot our conversation regarding methodology and just wrote a basic sanity check.
- "The usual" imperfect implementations that would happen if I coded things myself didn't magically disappear.

Regarding the various kinds of forgetting, I'd been hearing a lot that having agents work off of written specifications was better than driving the work through conversations. However, I really like working out details in conversations, sometimes long ones. It gives me opportunities for "oh, right, we also need ..." and "that reminds me ..." moments to draw out details. So I don't want to give that up.

Regarding general quality of the code, I found that having Claude implement code and GPT-5 review code led to a great jump in quality. 

Those observations inspired this project.

## What/How

This is a **meta-project**.
The associated **concrete** software development projects will use an **artifact-driven**, **multi-model** workflow system.
This **meta-project** designs and documents the workflow itself, not actual software that will be built in the concrete projects.
Though we may develop _some_ software here, such as evaluations of different model's abilities in different roles.

Managing development with artifacts is meant to address the "forgetting" via specifications as described above, but also extend beyond implementation to deciding what problems to solve (vision), what to attempt to include and what to not attempt (scope), mapping milestones (roadmap), etc. The artifacts also act as the communication mechanism between models.

That multi-model aspect is another generalization from the observations above. First, we are broadening it from multi-model to multi-role.
The same model with different instructions can effectively take on different roles.
In parallel with the artifacts, we can expand the initial idea to cover vision, scope, roadmaps, etc.

My theory is that a level of specificity and process which would be burdensome for human developers is appropriate for AI agents.
Reasons include the fact that agents can switch roles immediately by clearing context and loading a new prompt and that processes can be automated.

In this meta-project we will the following major components.
1. **[Ontology](Workflow/Ontology.md):** What kinds of documents exist; what they include; how the should be structured.
2. **[Role Catalog](Workflow/RoleCatalog.md):** What roles existl what they do; what artifacts they depend on; what artifacts they create or edit.
3. **[Workflow](Workflow/Workflow.md):** Who goes first; who goes next; who communicates with whom; when artifacts are created, edited, and read.
4. **[File Layout and Project State](Workflow/LayoutAndState.md):**
4. **Evals?** How do different models and/or different prompts perform in various roles. This might go elsewhere?

## Coming Soon

In another project that I've been rapidly iterating on and haven't gotten into git yet, I took some ideas from this project but added an email communication between the roles.
Results are _super_ interesting and I will merge that here eventually.
(Literal email. I monitor things using Mutt. Good memories.)
