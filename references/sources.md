# Source Registry

Last reviewed: 2026-10-22

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

## 2026-09-01 review notes (historical)

- OpenSpec's official changelog was at 1.11.0 while the local CLI was 1.6.0. The current official workflow uses a core `propose → apply → sync/archive` surface, exposes Codex through `openspec-*` skills, and requires explicit scope-bound confirmation before explore mode mutates files. Personal Flow therefore detects versions, uses only active/version-supported surfaces, keeps CE as implementation-plan owner, and reconciles a selected OpenSpec change at close.
- gstack's official changelog was at 1.77.0.0 while the local setup marker was 1.60.1.0. The core Personal Flow gates remain valid, but gstack now clearly separates `qa-only` report mode from `qa`, which performs a clean-tree test-fix-verify loop with atomic commits. Personal Flow defaults to non-mutating validation unless the fixing loop is authorized.
- The public Compound Engineering changelog was at 3.13.1 while the locally curated Codex plugin cache reported 3.24.0. The active local inventory is authoritative: review is split into `ce-code-review` and `ce-doc-review`, `ce-polish` is stable but explicit/user-directed, and the generic `ce-review` route must not be used.
- OMX's official changelog was at 0.21.1 and OMX was not installed locally. Version 0.21 consolidated or removed several old skills and introduced `omx autopilot`, while its docs still support task-specific `--worktree` launches and warn that native Windows/Codex App is not the recommended default. Personal Flow retains the user's original choice not to use Ralph/autopilot and limits OMX to explicitly approved parallel execution.

## 2026-10-22 review notes

Checked official repositories, changelogs, and workflow documentation on 2026-10-22. Upstream versions below are the latest observed at review time; they are not claims about locally installed versions.

- OpenSpec: latest observed release is 1.14.3 (2026-10-17). Its workflow documentation describes OPSX as fluid actions rather than mandatory phases; explore, verify, and sync are optional, and planning artifacts can be updated during implementation. Keep Personal Flow's lifecycle as the task-control record, and treat OpenSpec actions as optional capabilities within it. Version 1.14.3 also adds safer artifact glob path handling and fixes validation hangs in zero-width terminals. Sources: [releases](https://github.com/Fission-AI/OpenSpec/releases), [workflow guide](https://github.com/Fission-AI/OpenSpec/blob/main/docs/workflows.md), [changelog](https://github.com/Fission-AI/OpenSpec/blob/main/CHANGELOG.md).
- gstack: latest changelog entry observed is 1.91.176.0 (2026-10-21). The current release stream includes a distinct `qa-only` report path alongside the fixing `qa` loop; its QA guidance covers browser and non-browser surfaces such as CLI and API behavior. Keep report-only QA as the default; only use fixing QA when the user has authorized its source changes and commit behavior. Sources: [repository](https://github.com/garrytan/gstack), [QA guidance](https://github.com/garrytan/gstack#qa-without-a-webpage), [changelog](https://github.com/garrytan/gstack/blob/main/CHANGELOG.md).
- Compound Engineering: latest observed release is 3.31.1 (2026-10-21). The release list continues to use the `ce-*` gate model, with additions such as `ce-simplify-code` and ongoing cross-model changes. Keep the established Personal Flow gate owners (`ce-plan`, `ce-work`, `ce-code-review`/`ce-doc-review`, `ce-compound`) and use only skills exposed by the active host. Sources: [releases](https://github.com/EveryInc/compound-engineering-plugin/releases), [changelog](https://github.com/EveryInc/compound-engineering-plugin/blob/main/CHANGELOG.md).
- OMX: latest observed release is 0.21.28 (2026-10-21), a patch adding a JetBrains terminal scrolling diagnostic. The latest entry currently visible in `CHANGELOG.md` is 0.21.27, which continues work on team dispatch and recovery behavior, so the release page is the current version source when the changelog lags. OMX remains an optional runtime; use only the installed version's supported surface and do not substitute autopilot for Personal Flow. Sources: [repository](https://github.com/Yeachan-Heo/oh-my-codex), [releases](https://github.com/Yeachan-Heo/oh-my-codex/releases), [changelog](https://github.com/Yeachan-Heo/oh-my-codex/blob/main/CHANGELOG.md), [getting started](https://github.com/Yeachan-Heo/oh-my-codex/blob/main/docs/getting-started.html).

### Local capability check

The active session exposed no OpenSpec, gstack, Compound Engineering, or OMX skills. The local `~/.codex/skills` tree contained Personal Flow and system skills, with no checkout for those four upstream projects. `probe-frameworks.py` was attempted, but the macOS Git shim requested Xcode Command Line Tools and stopped before producing version data. Therefore local installed versions remain unknown; do not infer they are absent everywhere or claim they are current. Re-run the probe when Git is available.

## Refresh rule

When asked to refresh Personal Flow, compare each official changelog and workflow page with `python3 scripts/probe-frameworks.py <repo>` output and the current session's exposed skill inventory. Update routing only for documented behavior that changes a Personal Flow decision. A refresh of Personal Flow does not itself install or upgrade the separate upstream frameworks; do that only when explicitly requested.
