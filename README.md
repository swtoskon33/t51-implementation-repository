# T5.1 — Implementation Repository

Public index of open-source reference implementations relevant to EuroQCI
standardisation (ETSI GS QKD interfaces), reviewed under Task 5.1. This
repository is the **MS5.1** deliverable: it points to the selected
implementations and keeps them organised by category.

## All tools

<!-- TOOLS-TABLE:START -->
| Tool | Category | Description |
| --- | --- | --- |
| [Next Door Key Simulator](https://github.com/CreepPork/next-door-key-simulator) | Emulation |  |
| [QKDNetSim](https://github.com/QKDNetSim/qkdnetsim) | Emulation |  |
| [ETSI GS QKD 014 Reference Implementation (cybermerqury)](https://github.com/cybermerqury/etsi-gs-qkd-014-referenceimplementation) | Control Management |  |
| [qkd_kme_server](https://github.com/thomasarmel/qkd_kme_server) | Control Management |  |
| [QUBIP etsi-qkd-004](https://github.com/QUBIP/etsi-qkd-004) | Control Management |  |
| [TeraFlowSDN](https://labs.etsi.org/rep/tfs/controller) | Control Management |  |
| [TU/e ETSI-QKD014 client](https://github.com/TUe-QTS/ETSI-QKD014-client) | Control Management |  |
| [qkd-etsi-api-c-wrapper](https://github.com/qursa-uc3m/qkd-etsi-api-c-wrapper) | Hybrid |  |
<!-- TOOLS-TABLE:END -->

This table is generated automatically from the YAML entries below by
`scripts/build_catalog.py` — do not edit it by hand.

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
landscape-review Excel and are not duplicated here.

> Link to the landscape-review Excel: _add the internal/shared link here
> before dissemination._

## How the repository is organised

| Folder | Category | Coverage |
|---|---|---|
| [`/emulation`](./emulation) | Emulation | Tools that emulate QKD protocols, links or networks without physical devices |
| [`/control-management`](./control-management) | Control & management | KME/KMS, clients, SDN control, orchestration, monitoring |
| [`/hybrid`](./hybrid) | Hybrid | Tools that bridge software with real QKD devices |

Each folder contains:

- `README.md` — short description of the category
- `index.md` — the human-readable table for that category (generated)
- `entries/*.yaml` — one file per implementation, in the format above

The repository-wide index is [`catalog.csv`](./catalog.csv), regenerated from
the YAML files with `python3 scripts/build_catalog.py`.

## Adding an entry

Copy `TEMPLATE.yaml` into the right `entries/` folder, fill in the four
fields, open a pull request — see [CONTRIBUTING.md](./CONTRIBUTING.md). Then
run:

```bash
python3 scripts/build_catalog.py && git add -A && git commit -m "Update catalog" && git push
```

This regenerates the table above, each category's `index.md`, and
`catalog.csv` in one step.

## Licence

Content in this repository is released under [CC BY 4.0](./LICENSE).
