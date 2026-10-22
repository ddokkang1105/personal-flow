#!/usr/bin/env python3
"""Read-only detection of optional Personal Flow frameworks on macOS/Linux."""
import json, os, shutil, subprocess, sys
from pathlib import Path

project = Path(sys.argv[1] if len(sys.argv) > 1 else ".").expanduser().resolve()
home = Path.home()
codex = Path(os.environ.get("CODEX_HOME", home / ".codex")).expanduser()
skill_roots = [codex / "skills", project / ".agents/skills", project / ".codex/skills"]
def names(patterns):
    found = set()
    for root in skill_roots:
        if root.is_dir():
            for child in root.iterdir():
                if child.is_dir() and any(__import__('fnmatch').fnmatch(child.name, p) for p in patterns): found.add(child.name)
    return sorted(found)
def version(command):
    if not command: return None
    try: return subprocess.run([command, "--version"], capture_output=True, text=True, timeout=5).stdout.splitlines()[0].strip()
    except Exception: return None
openspec, gstack = names(["openspec-*", "opsx*"]), names(["gstack", "gstack-*"])
ce_root = codex / "plugins/cache/compound-engineering-plugin/compound-engineering"
ce_versions = sorted([p.name for p in ce_root.iterdir() if p.is_dir()] if ce_root.is_dir() else [])
ce_skills = []
if ce_versions: ce_skills = sorted(p.name for p in (ce_root / ce_versions[-1] / "skills").iterdir() if p.is_dir()) if (ce_root / ce_versions[-1] / "skills").is_dir() else []
openspec_cmd, node_cmd, omx_cmd = shutil.which("openspec"), shutil.which("node"), shutil.which("omx")
print(json.dumps({
 "projectRoot": str(project), "environment": {"os": sys.platform, "codexHome": str(codex)},
 "openspec": {"available": bool(openspec_cmd and node_cmd or (project/"openspec").exists() or openspec), "command": openspec_cmd, "version": version(openspec_cmd), "nodeCommand": node_cmd, "cliReady": bool(openspec_cmd and node_cmd), "projectArtifacts": (project/"openspec").exists(), "installedSkills": openspec, "activationRequired": "Use only an OpenSpec skill active in this session or a command supported by the installed CLI version.", "route": "Optional task/spec owner; keep CE as the implementation-plan owner and reconcile the change at close."},
 "gstack": {"available": bool(gstack), "version": ((home/".gstack/.last-setup-version").read_text().splitlines()[0].strip() if (home/".gstack/.last-setup-version").exists() else None), "installedSkillCount": len(gstack), "coreSkills": [x for x in ["gstack-office-hours","gstack-plan-ceo-review","gstack-plan-eng-review","gstack-plan-design-review","gstack-qa","gstack-qa-only"] if x in gstack], "activationRequired": "A matching gstack skill must be active in the current Codex session.", "route": "Use selected product, architecture, design, QA-only, or authorized QA fix-loop gates."},
 "compoundEngineering": {"available": bool(ce_skills), "versions": ce_versions, "activeCacheVersion": ce_versions[-1] if ce_versions else None, "coreSkills": [x for x in ["ce-ideate","ce-brainstorm","ce-plan","ce-work","ce-code-review","ce-doc-review","ce-polish","ce-compound"] if x in ce_skills], "activationRequired": "A matching CE skill must be active in this Codex session.", "route": "Use CE for ideate/brainstorm, plan, work, code/doc review, explicit polish, and compound."},
 "omx": {"available": bool(omx_cmd), "command": omx_cmd, "version": version(omx_cmd), "projectArtifacts": (project/".omx").exists(), "hostCaution": "Verify runtime before launch; native Windows and Codex App are not the recommended default." if sys.platform == "win32" else None, "activationRequired": "Use only after explicit approval of the exact team or task-specific worktree launch.", "route": "Optional parallel runtime only; Personal Flow does not adopt OMX autopilot or Ralph."}
}, ensure_ascii=False, indent=2))
