#!/usr/bin/env python3
"""Create a Personal Flow task from the bundled templates."""
import argparse
import re
import shutil
from datetime import date
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--title", required=True)
parser.add_argument("--profile", choices=("small", "standard", "large"), default="standard")
parser.add_argument("--root", type=Path, default=Path.cwd() / ".flow")
args = parser.parse_args()
slug = re.sub(r"[^\w]+", "-", args.title.lower(), flags=re.UNICODE).strip("-")
if not slug:
    raise SystemExit("Title must contain at least one letter or number.")
script_dir = Path(__file__).resolve().parent
template_root = script_dir.parent / "assets" / "templates"
task_root = args.root / "tasks" / slug
if task_root.exists():
    raise SystemExit(f"Task already exists: {task_root}")
(args.root / "tasks").mkdir(parents=True, exist_ok=True)
(args.root / "knowledge").mkdir(parents=True, exist_ok=True)
task_root.mkdir(parents=True)
for src in template_root.iterdir():
    if src.is_file():
        shutil.copy2(src, task_root / src.name)
task_file = task_root / "task.md"
task_file.write_text(task_file.read_text().replace("<title>", args.title), encoding="utf-8")
state_file = task_root / "state.yaml"
state = state_file.read_text(encoding="utf-8").replace("profile: standard", f"profile: {args.profile}").replace("updated: YYYY-MM-DD", f"updated: {date.today().isoformat()}")
state_file.write_text(state, encoding="utf-8")
print(f"Created task: {task_root}")
