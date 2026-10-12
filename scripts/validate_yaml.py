#!/usr/bin/env python3
"""Parse every YAML-backed project configuration and report exact failures."""

from pathlib import Path
import sys

try:
    import yaml
except ImportError:
    print("PyYAML is unavailable; install python-yaml/python3-yaml", file=sys.stderr)
    raise SystemExit(2)


ROOT = Path(__file__).resolve().parent.parent
FILES = [
    *sorted((ROOT / ".github" / "workflows").glob("*.yml")),
    *sorted(
        (ROOT / "packages" / "lokro-installer-config" / "rootfs" / "etc" / "calamares").rglob("*.conf")
    ),
    ROOT
    / "packages"
    / "lokro-installer-config"
    / "rootfs"
    / "etc"
    / "calamares"
    / "branding"
    / "lokro"
    / "branding.desc",
]

errors = 0
for path in FILES:
    try:
        with path.open("r", encoding="utf-8") as stream:
            yaml.safe_load(stream)
    except (OSError, yaml.YAMLError) as exc:
        errors += 1
        print(f"ERROR {path.relative_to(ROOT)}: {exc}", file=sys.stderr)

if errors:
    raise SystemExit(1)

print(f"YAML validation passed ({len(FILES)} files)")
