#!/usr/bin/env python3
import csv
import pathlib
import re
import sys

try:
    import yaml
except ImportError:
    sys.exit("Install pyyaml first: pip3 install pyyaml")

ROOT = pathlib.Path(__file__).resolve().parent.parent
CATEGORIES = ["emulation", "control-management", "hybrid"]
REQUIRED_FIELDS = ["name", "link", "category"]
ALL_FIELDS = REQUIRED_FIELDS + ["description"]

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
            sys.exit(f"{yaml_file}: category mismatch with folder {category}")
        data.setdefault("description", "")
        entries.append(data)
        rows.append(data)

    index_path = ROOT / category / "index.md"
    lines = [f"# {category.replace('-', ' ').title()}", "",
             "| Tool | Description |", "| --- | --- |"]
    for e in entries:
        lines.append(f"| [{e['name']}]({e['link']}) | {e['description']} |")
    index_path.write_text("\n".join(lines) + "\n")
    print(f"Wrote {index_path} ({len(entries)} entries)")

catalog_path = ROOT / "catalog.csv"
with catalog_path.open("w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=ALL_FIELDS)
    writer.writeheader()
    writer.writerows(rows)
print(f"Wrote {catalog_path} ({len(rows)} entries total)")

readme_path = ROOT / "README.md"
readme_text = readme_path.read_text()
table_lines = ["| Tool | Category | Description |", "| --- | --- | --- |"]
for e in rows:
    cat_label = e["category"].replace("-", " ").title()
    table_lines.append(f"| [{e['name']}]({e['link']}) | {cat_label} | {e['description']} |")
table_block = "\n".join(table_lines)

new_readme, n = re.subn(
    r"<!-- TOOLS-TABLE:START -->\n.*?<!-- TOOLS-TABLE:END -->",
    f"<!-- TOOLS-TABLE:START -->\n{table_block}\n<!-- TOOLS-TABLE:END -->",
    readme_text,
    flags=re.DOTALL,
)
if n != 1:
    sys.exit("README.md markers not found — run the one-off marker setup first")
readme_path.write_text(new_readme)
print("Updated README.md tools table")
