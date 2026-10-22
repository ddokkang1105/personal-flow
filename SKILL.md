---
name: personal-flow
description: Run a personal software-development task workflow from task definition through discovery, planning, implementation, review, QA, and reusable learning. Use when the user asks to start, continue, plan, review, QA, close, or coordinate a task with the Personal Flow, or asks to apply their OpenSpec, gstack, Compound Engineering, and OMX workflow.
---

# Personal Flow

Use Personal Flow as a thin control plane. Keep the external frameworks independent; route work to them when they are installed and appropriate. Store canonical task state and artifacts in `.flow/`.

## Start or Resume

1. Locate `.flow/`. If absent, copy `assets/templates/` into `.flow/templates/` and create `.flow/tasks/` and `.flow/knowledge/`.
2. Run `python3 scripts/probe-frameworks.py <repo>` and read `references/framework-routing.md` before selecting optional gates. Record installed versions, the active skill or CLI actually used, and any fallback in the task artifacts. Detection alone is not activation.
3. For a new task, run `python3 scripts/new-task.py --title "<title>"` from the repository root, or create a slugged folder in `.flow/tasks/` and copy all task templates into it.
4. Read `state.yaml`, then announce the current stage and the next concrete action.
5. Update the relevant artifact and `state.yaml` before leaving a stage. Do not mark a gate complete without its written result.

Use this lifecycle:

```text
task -> discover? -> brainstorm? -> plan -> work -> review -> polish? -> qa -> close
                           ^                  |                   |
                           +------ rework ----+-------- rework ----+
```

## Select Gates

Choose the smallest useful profile. Record every choice under `gates` in `state.yaml`.

| Profile | Required flow | Add gates when |
|---|---|---|
| small | plan, work, review, QA, close | a change affects more than one area or has unclear acceptance criteria |
| standard | discover/brainstorm as needed, plan, work, review, QA, close | requirements or approach are unclear |
| large | discovery reviews, brainstorm, plan, work, review, QA, close | architecture, security, major UX, or several independent workstreams change |

Select one owner for each gate. Do not run equivalent gates from several frameworks only because they are installed.

Apply these routing rules:

- OpenSpec is optional and limited to task/spec ownership. In Codex it is normally exposed as active `openspec-*` skills; other hosts may expose `/opsx:*` commands. Use only the exact surface visible in the current session. Keep CE as implementation-plan owner, summarize the accepted OpenSpec change in `.flow/tasks/<slug>/task.md`, and record the OpenSpec change name so it can be reconciled at close. OpenSpec actions are fluid rather than mandatory phases: use `update` when implementation changes the plan, and select `verify` or `sync` only when useful for the chosen change.
- gstack owns selected product, architecture, design, and QA gates. Use active `office-hours`, `plan-ceo-review`, `plan-eng-review`, and `plan-design-review` skills when their gate is selected. Use `qa-only` to validate and report on web, CLI, API, or other software behavior without changing product code or tests. Use `qa` for a test-fix-verify loop only when the user requested fixes and authorized its source changes, clean-tree handling, and commit behavior.
- Compound Engineering (CE) is the main execution loop. Use active `ce-ideate` only for idea generation, `ce-brainstorm` for requirements, `ce-plan` for the executable plan, `ce-work` for implementation, `ce-code-review` or `ce-doc-review` for review, and `ce-compound` for knowledge capture. `ce-polish` is an explicit, user-directed browser feedback loop, not an automatic gate.
- OMX is an optional parallel runtime, not the lifecycle owner. Do not replace Personal Flow with OMX autopilot, Ralph, or another fixed chain. When independent workstreams justify it, use an active `$team`-style skill or present an exact task-specific worktree launch such as `omx --worktree=<name> --madmax --xhigh`. Launch only after explicit approval and only on a supported, verified runtime.

Detection means a framework is installed locally; it does not prove that its skill is loaded in this Codex session or that every documented command exists in the installed version. Invoke only the actual matching skill or version-supported CLI exposed to the active session. If it is unavailable, perform the intended analysis directly and record the fallback in `decisions.md`, `review.md`, or `qa.md`. Do not invent slash commands, auto-upgrade frameworks, or silently widen permissions.

## Operate Each Stage

### Task

Use the personal task template by default. When OpenSpec is selected, use its active explore surface for read-only clarification and its active propose surface for a durable change specification. Then fill `task.md` with the OpenSpec change name, goal, non-goals, acceptance criteria, constraints, and profile. Keep requirements testable. OpenSpec actions do not have to follow Personal Flow stage boundaries; update its planning artifacts when implementation reveals a material change, and use optional verify/sync actions when the change and active version support them.

### Discover and Brainstorm

Run only the selected gstack review skills and/or the matching CE ideate or brainstorm skill. Consolidate decided outcomes, rejected options, and open questions in `decisions.md`. Do not create an implementation plan while material questions remain open.

### Plan

Use the active CE plan skill. Write an ordered, verifiable plan in `plan.md`, including affected paths, test/QA method, and rollback or migration steps when relevant. Keep runtime progress in `state.yaml` and record plan deviations separately instead of rewriting the plan into a status log. Change `stage` to `work` only when the plan is executable.

### Work

Use the active CE work skill, then implement plan items in order. Keep `state.yaml` current and amend `plan.md` only for approved scope or approach changes. For approved OMX work, give each agent a bounded, non-overlapping outcome; integrate and verify its result before marking the item complete.

### Review

Run `ce-code-review` for code changes and `ce-doc-review` for planning or documentation artifacts when the matching skill is active. Capture findings by severity, disposition, and verification in `review.md`. Reopen `plan` for design/scope issues and `work` for bounded implementation fixes. Do not send unresolved high-severity findings to QA.

### Polish

Offer `ce-polish` only for a working browser feature that needs user-directed UX refinement. Run it only when the user explicitly asks for or accepts the live feedback loop. Record resulting fixes in `review.md` and re-review material changes before QA.

### QA

Default to validation without code changes. For web applications and non-web software such as CLIs or APIs, use active gstack `qa-only` for test, verification, or report requests when available; it may gather evidence and recommend regression cases but must not change product code or tests. Otherwise run equivalent repository-appropriate validation directly. Use active gstack `qa` only for a user-requested test-fix-verify loop when source fixes, clean-tree handling, and atomic commits are authorized. Record exact commands, manual scenarios, observed results, fixes, and remaining limits in `qa.md`. A passing build alone is not sufficient unless it is the only acceptance criterion.

### Close

If OpenSpec was selected, reconcile the implementation with its artifacts using the active verification surface or version-supported validation. Sync and archive the OpenSpec change only after its requirements and tasks are complete and the Personal Flow task is ready to close. Run the active CE compound skill to create or update reusable knowledge; if unavailable, add a concise learning to `.flow/knowledge/learnings.md`. Finalize `followups.md`, set `stage: closed` only when every acceptance criterion and required QA gate passes, and report the outcome with verification evidence.

## Resources

- Read `references/framework-routing.md` when deciding which external framework or gate to use.
- Read `references/sources.md` when checking upstream documentation, versions, renamed skills, or updating this workflow.
- Read `references/practical-operations-checklist.md` when drafting a repo-backed work prompt, defining completion evidence, or standardizing an implementation handoff. It is operating guidance, not an additional lifecycle gate.
- Copy `assets/templates/` for a new `.flow` installation or task.
- Use `python3 scripts/new-task.py --title "<title>"` to create a task folder and initialize its state.
- Use `python3 scripts/probe-frameworks.py <repo>` to detect local OpenSpec, gstack, CE, and OMX versions and availability without changing the environment.
