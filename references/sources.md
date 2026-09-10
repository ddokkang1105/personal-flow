# Source Registry

Last reviewed: 2026-09-01

Personal Flow is an independent control plane. It does not vendor or merge these projects; it routes selected gates to installed, active integrations and keeps canonical task records in `.flow/`.

| Project | Personal Flow role | Official sources |
|---|---|---|
| OpenSpec | Optional task and durable specification owner | [Repository](https://github.com/Fission-AI/OpenSpec) · [Changelog](https://github.com/Fission-AI/OpenSpec/blob/main/CHANGELOG.md) · [Workflows](https://github.com/Fission-AI/OpenSpec/blob/main/docs/workflows.md) · [Commands](https://github.com/Fission-AI/OpenSpec/blob/main/docs/commands.md) |
| gstack | Product, architecture, design, and browser-QA gates | [Repository](https://github.com/garrytan/gstack) · [Changelog](https://github.com/garrytan/gstack/blob/main/CHANGELOG.md) |
| Compound Engineering | Main brainstorm, plan, work, review, polish, and compound loop | [Repository](https://github.com/EveryInc/compound-engineering-plugin) · [Changelog](https://github.com/EveryInc/compound-engineering-plugin/blob/main/CHANGELOG.md) |
| Oh My Codex (OMX) | Optional parallel team/worktree runtime | [Repository](https://github.com/Yeachan-Heo/oh-my-codex) · [Changelog](https://github.com/Yeachan-Heo/oh-my-codex/blob/main/CHANGELOG.md) · [Getting started](https://github.com/Yeachan-Heo/oh-my-codex/blob/main/docs/getting-started.html) |

Historical companion reference: [oh-my-claudecode](https://github.com/yeachan-heo/oh-my-claudecode). It is not the runtime source for Codex; use the official Oh My Codex repository and `oh-my-codex` package for OMX.

## Practitioner field notes

These sources provide experience-based operating ideas, not product specifications. Use them to improve prompts and checklists, but verify version-sensitive claims against the current host, installed tools, and official documentation before changing workflow behavior.

| Source | Personal Flow use | Authority |
|---|---|---|
| [현업 10년차 개발자의 codex 사용팁](https://blog.naver.com/jhc9639/224186400602) | Task decomposition, evidence-based verification, review handoffs, work isolation, and reusable prompt patterns | Practitioner field note; non-authoritative and version-sensitive |

## 2026-09-01 review notes

- OpenSpec's official changelog was at 1.11.0 while the local CLI was 1.6.0. The current official workflow uses a core `propose → apply → sync/archive` surface, exposes Codex through `openspec-*` skills, and requires explicit scope-bound confirmation before explore mode mutates files. Personal Flow therefore detects versions, uses only active/version-supported surfaces, keeps CE as implementation-plan owner, and reconciles a selected OpenSpec change at close.
- gstack's official changelog was at 1.77.0.0 while the local setup marker was 1.60.1.0. The core Personal Flow gates remain valid, but gstack now clearly separates `qa-only` report mode from `qa`, which performs a clean-tree test-fix-verify loop with atomic commits. Personal Flow defaults to non-mutating validation unless the fixing loop is authorized.
- The public Compound Engineering changelog was at 3.13.1 while the locally curated Codex plugin cache reported 3.24.0. The active local inventory is authoritative: review is split into `ce-code-review` and `ce-doc-review`, `ce-polish` is stable but explicit/user-directed, and the generic `ce-review` route must not be used.
- OMX's official changelog was at 0.21.1 and OMX was not installed locally. Version 0.21 consolidated or removed several old skills and introduced `omx autopilot`, while its docs still support task-specific `--worktree` launches and warn that native Windows/Codex App is not the recommended default. Personal Flow retains the user's original choice not to use Ralph/autopilot and limits OMX to explicitly approved parallel execution.

## Refresh rule

When asked to refresh Personal Flow, compare each official changelog and workflow page with `scripts/probe-frameworks.ps1` output and the current session's exposed skill inventory. Update routing only for documented behavior that changes a Personal Flow decision. Do not install or upgrade an upstream framework without a separate user request.
