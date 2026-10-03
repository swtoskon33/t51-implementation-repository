# Smoke tests

One script per candidate. Each script clones the tool into `~/t51-work`, starts it in the background, performs one key exchange and writes a short report to `~/t51-work/reports`.

| Script | Tool | Requirements |
|---|---|---|
| `qkd_kme_server.sh` | qkd_kme_server | Rust toolchain |
| `next_door_key_simulator.sh` | Next Door Key Simulator | Docker |
| `qubip_etsi_qkd_004.sh` | QUBIP etsi-qkd-004 | Docker |

Run from the repository root, for example:

```bash
bash scripts/smoke/qkd_kme_server.sh
```

Reports stay local and are used to update the Known issues section of each `run/*.md` file.
