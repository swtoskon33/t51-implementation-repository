# T5.1 — Implementation Repository

Public index of open-source reference implementations relevant to EuroQCI
standardisation (ETSI GS QKD interfaces), reviewed under Task 5.1. This
repository is the **MS5.1** deliverable: it points to the selected
implementations and keeps them organised by category.

## Entry format

Each implementation is one YAML file under a category's `entries/` folder.
Every entry has exactly four fields:

- `name` — the tool's official name, as its authors write it
- `link` — canonical URL: project homepage or source repository
- `category` — one of `emulation`, `control-management`, `hybrid`; must match the folder the file is in
- `description` — one short sentence on what the tool is and does

Example:

```yaml
name: "qkd_kme_server"
link: "https://github.com/thomasarmel/qkd_kme_server"
category: "control-management"
description: "ETSI GS QKD 014 KME server in Rust, serves keys over mutual TLS and connects to remote KMEs."
```

These four fields are the only metadata tracked here. Licence, ETSI spec
coverage, maturity, scoring and test results live in the accompanying
landscape-review Excel and are not duplicated here — the Excel is the
working document, this repository is the stable, citable, public face of
the task.

> Link to the landscape-review Excel: _add the internal/shared link here
> before dissemination._

## How the repository is organised

| Folder | Category | Coverage |
|---|---|---|
| [`/emulation`](./emulation) | Emulation | Tools that emulate QKD protocols, links or networks without physical devices |
| [`/control-management`](./control-management) | Control & management | KME/KMS, clients, SDN control, orchestration, monitoring |
| [`/hybrid`](./hybrid) | Hybrid | Tools that bridge software with real QKD devices |

Each folder contains:

- `index.md` — the human-readable list for that category
- `entries/*.yaml` — one file per implementation, in the format above

The repository-wide index is [`catalog.csv`](./catalog.csv), regenerated from
the YAML files with `python3 scripts/build_catalog.py`.

## Adding an entry

See [CONTRIBUTING.md](./CONTRIBUTING.md). In short: copy `TEMPLATE.yaml` into
the right `entries/` folder, fill in the four fields, open a pull request.

## Licence

Content in this repository (README, index files, entry metadata) is released
under [CC BY 4.0](./LICENSE). See [LICENSE](./LICENSE) for the reasoning.
