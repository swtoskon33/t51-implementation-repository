# Contributing an entry

This repository only tracks pointers (name, link, category). Full review
details (licence, ETSI coverage, maturity, scoring) belong in the
landscape-review Excel, not here.

## To propose a new entry

1. Copy `TEMPLATE.yaml` into the correct `entries/` folder
   (`emulation/entries/`, `control-management/entries/` or
   `hybrid/entries/`).
2. Rename it to a short slug of the tool name, e.g. `my-tool.yaml`.
3. Fill in `name`, `link`, `category` (must match the folder), `description`
   and `pinned_commit`.
4. Optionally add `run/<slug>.md` with requirements, installation steps and
   known issues.
5. Run `python scripts/build_catalog.py` to regenerate `index.md` and
   `catalog.csv`, and include the regenerated files in your commit.
6. Open a pull request. New entries are merged after a WP5 reviewer
   confirms the tool has already been logged in the landscape-review
   Excel (licence check, ETSI coverage, scoring).

## Removing or moving an entry

Delete the YAML file (or move it to a different category folder), then
re-run `python scripts/build_catalog.py` and commit the regenerated files.
