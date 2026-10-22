# Framework Routing

| Need | Preferred framework | Canonical output |
|---|---|---|
| Fast task/spec | Personal task template; optional OpenSpec propose | `task.md` + OpenSpec change name |
| Read-only requirement exploration | OpenSpec explore or gstack office-hours | `decisions.md` |
| Early product thinking | gstack office-hours / CEO review | `decisions.md` |
| Architecture or implementation risk | gstack engineering review | `decisions.md` |
| UX or visual risk | gstack design review | `decisions.md` |
| Idea generation | CE ideate | `decisions.md` |
| Requirement discovery | CE brainstorm | `decisions.md` |
| Executable plan | CE plan | `plan.md` |
| Implementation | CE work | repository changes + `plan.md` |
| Code review | CE code review | `review.md` |
| Plan or document review | CE doc review | `review.md` or `decisions.md` |
| User-directed UX refinement | CE polish | repository changes + `review.md` |
| Parallel independent work | OMX team/worktree runtime | integrated repository changes |
| Report-only validation (web, CLI, API, or other software) | gstack QA-only | `qa.md` |
| Authorized test-fix-verify | gstack QA | fixes + `qa.md` |
| Reusable learning | CE compound | `.flow/knowledge/learnings.md` or linked note |

## Availability and safety

Run `python3 scripts/probe-frameworks.py <repo>` at task start. Its result is capability detection, not permission to launch another runtime or proof that a skill is loaded.

- OpenSpec: Codex normally exposes project skills named `openspec-*` under `.agents/skills`; other hosts may expose `/opsx:*`. Use the actual active integration. OPSX is action-based, not phase-locked: planning artifacts can be updated during implementation, while explore, verify, and sync are optional. Keep OpenSpec to task/spec ownership in Personal Flow, track its change name, and reconcile it at close.
- gstack: use the active skill matching the selected gate. `qa-only` is report mode for browser and non-browser behavior (including CLI and API); it must not change product code or tests. `qa` reproduces bugs, writes regression tests, fixes source, re-verifies, and commits, so use it only when the user authorized that full loop. On Codex, verify the active generated skill is available before routing a gate to gstack.
- CE: use active `ce-ideate`, `ce-brainstorm`, `ce-plan`, `ce-work`, `ce-code-review`, `ce-doc-review`, `ce-polish`, and `ce-compound` according to stage. Do not route to the retired generic `ce-review` name.
- OMX: use only for independent workstreams. The current OMX surface includes independent skills such as `$team` and a separate autopilot chain; Personal Flow deliberately does not adopt autopilot or Ralph. Require explicit approval for the exact team/worktree launch. Native Windows and the Codex App are not OMX's recommended default runtime, so verify the environment before proposing a launch.
- If a framework is detected but the matching skill is inactive, use a direct fallback and record it. Do not tell the user to restart unless reloading the skill is genuinely required for the requested gate.
- Installed and upstream versions may differ. Never auto-upgrade as part of a Personal Flow task; report drift and use only installed, verified capabilities.

## Gate Heuristics

- Skip discovery for a narrowly specified, low-risk task.
- Require engineering review for a public API, data migration, security boundary, cross-module architecture, or high-impact performance change.
- Require design review for a changed user journey, interaction model, or visual system.
- Use CE polish only after the feature works and the user wants live UX refinement.
- Use OMX only after the plan identifies independent files, modules, or research questions and defines an integration owner.
- Return to brainstorm when requirements change; return to plan when approach or task order changes; return to work when a review or QA finding has a bounded fix.

## Source maintenance

Read `sources.md` before changing framework names or lifecycle ownership. Compare official changelogs with the versions reported by the probe. Prefer the current session's exposed skill inventory when a local curated plugin version is newer than, or versioned differently from, its public changelog.
