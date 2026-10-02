#!/usr/bin/env python3
"""Regenerate catalog.csv and each category index.md from the YAML entries.
Run from the repo root: python scripts/build_catalog.py
"""
import csv
import pathlib
import sys

try:
    import yaml
except ImportError:
    sys.exit("Install pyyaml first: pip install pyyaml")

ROOT = pathlib.Path(__file__).resolve().parent.parent
CATEGORIES = ["emulation", "control-management", "hybrid"]
REQUIRED_FIELDS = ["name", "link", "category"]

rows = []
for category in CATEGORIES:
    entries_dir = ROOT / category / "entries"
    entries = []
    for yaml_file in sorted(entries_dir.glob("*.yaml")):
        data = yaml.safe_load(yaml_file.read_text())
        missing = [f for f in REQUIRED_FIELDS if not data.get(f)]
        if missing:
            sys.exit(f"{yaml_file}: missing field(s) {missing}")
        if data["category"] != category:
            sys.exit(f"{yaml_file}: category '{data['category']}' does not "
                      f"match its folder '{category}'")
        entries.append(data)
        rows.append(data)

    index_path = ROOT / category / "index.md"
    lines = [f"# {category.replace('-', ' ').title()}", ""]
    for e in entries:
        lines.append(f"- [{e['name']}]({e['link']})")
    index_path.write_text("\n".join(lines) + "\n")
    print(f"Wrote {index_path} ({len(entries)} entries)")

catalog_path = ROOT / "catalog.csv"
with catalog_path.open("w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=REQUIRED_FIELDS)
    writer.writeheader()
    writer.writerows(rows)
print(f"Wrote {catalog_path} ({len(rows)} entries total)")
