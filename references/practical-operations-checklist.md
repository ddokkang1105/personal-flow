# Practical Operations and Prompt Checklist

Use this reference when starting repo-backed work, delegating a bounded unit, or checking whether a reported result is ready for review. It supplements the Personal Flow lifecycle; it does not add a gate, replace framework routing, or grant permission for commits, pushes, external publication, or additional runtimes.

## Required operating rules

### 1. Decompose the work

- Convert the request into a bounded outcome with testable acceptance criteria.
- Split large work into ordered, independently verifiable units such as design, minimal implementation, tests, and focused cleanup.
- Keep dependent units sequential. Parallelize only units with non-overlapping ownership and a defined integration check.
- Do not mix unrelated fixes or speculative improvements into the active unit.

### 2. Ground the prompt in context

- Name the relevant repository, paths, current behavior, constraints, and known commands when they are available.
- Inspect the actual files, configuration, logs, and test output before claiming how the system works.
- State material assumptions and resolve any assumption that could change scope, architecture, security, or user-visible behavior.
- Treat user-named files, URLs, tools, and prior artifacts as inputs that must be checked, not silently replaced.

### 3. Define completion before implementation

- Describe the intended observable result, non-goals, and acceptance criteria.
- List the exact repository-appropriate verification commands when known.
- Define the required report: changed files, key behavior or diff, verification results, risks, rollback, and unverified limits.
- Never accept an agent's statement that work is complete without observable evidence proportional to the change.

### 4. Use executable verification

- Run the relevant tests, linter, type checker, build, or focused runtime scenario supported by the repository.
- Record the exact commands and their observed results. Do not claim a check passed when it was unavailable, skipped, or only inferred.
- Add or update tests when behavior changes and suitable coverage is in scope. Explain deliberate exceptions.
- A passing build is not a substitute for behavioral acceptance criteria unless the build is the only criterion.

### 5. Follow applicable `AGENTS.md` instructions

- Before editing, locate and read every `AGENTS.md` whose scope covers a target file.
- Follow project-specific package-manager, dependency, test, style, and safety rules from the most specific applicable file.
- Do not create or expand `AGENTS.md` merely to store one-off preferences. Propose an update only when a durable repository convention is missing and the user has authorized that scope.

### 6. Investigate from evidence

- Search the repository before designing an unfamiliar change and cite concrete paths, symbols, logs, or command results in conclusions.
- When evidence is missing, label the statement as an assumption or limitation instead of filling the gap with a confident guess.
- For defects, distinguish reproduction evidence, root-cause evidence, the minimal fix, and regression verification.

### 7. Report the change like a review handoff

Include:

1. changed files and the purpose of each change;
2. the key behavior or diff, without narrating every edit;
3. verification commands and results;
4. known side effects, security or compatibility risk, and remaining limits;
5. rollback steps when the change is difficult to reverse or operationally sensitive.

Do not commit, push, publish an issue, deploy, or mutate an external system unless that action is explicitly authorized.

## Optional recommendations

### Branches, worktrees, and parallel work

- Use a separate branch or worktree when independent work must proceed concurrently or isolation materially improves rollback.
- Verify that Git, the host, and the selected runtime support the proposed isolation method before using it.
- Give every worker a bounded, non-overlapping outcome and keep one integration owner responsible for reviewing and verifying the combined result.
- Do not enable a feature flag, launch another runtime, or adopt an autopilot chain solely because an example recommends it.

### Reasoning effort

- Prefer lower effort for mechanical, well-bounded edits with strong verification.
- Prefer higher effort for architecture, security, migrations, performance investigations, or ambiguous cross-module changes.
- Treat model names, effort levels, feature flags, and configuration keys as environment-dependent. Use only values exposed by the current host and version.

### Reusable prompts and skills

- Turn a prompt into a skill only after the task recurs and its durable decisions, inputs, outputs, safety boundaries, and stopping conditions are understood.
- Keep generic capability in the agent; store only guidance that changes decisions or prevents repeated mistakes.
- Put detailed, situational procedures in `references/` and keep the main `SKILL.md` concise.
- Validate a changed skill with its available validator and a realistic invocation when warranted.

## Prompt contract template

Use only the fields that improve the task; do not add ceremony to a trivial edit.

```text
Outcome:
- <observable result>

Context:
- Repository/path:
- Relevant files, logs, or prior artifacts:
- Current behavior:

Scope:
- In scope:
- Non-goals:
- Constraints and permissions:

Completion criteria:
- <testable criterion>

Verification:
- <command or manual scenario>

Report:
- Changed files and key behavior
- Verification evidence
- Risks, rollback, and unverified limits
```

## Source posture

This checklist combines existing Personal Flow safety and verification rules with a practitioner field note recorded in `sources.md`. Practitioner sources can suggest useful habits, but current host capabilities, repository instructions, installed versions, and explicit user authorization remain authoritative for execution.
