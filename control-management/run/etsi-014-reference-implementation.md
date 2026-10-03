# ETSI GS QKD 014 Reference Implementation (Merqury)

**Requirements:** Ubuntu 22.04, Rust 1.80.1, sqlx-cli, Docker, make, OpenSSL, moreutils. Single workstation or VM.

```bash
sudo apt install build-essential curl libssl-dev moreutils pkg-config
curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain=1.80.1 -y
cargo install sqlx-cli --no-default-features --features rustls,postgres
git clone https://github.com/cybermerqury/etsi-gs-qkd-014-referenceimplementation.git
cd etsi-gs-qkd-014-referenceimplementation
make setup            # certificates, PostgreSQL container, migrations
make run_server
make get_enc_key      # second terminal
make get_dec_key KEY='<KEY_ID>'
```

## Known issues

- Rust toolchain pinned to 1.80.1.
- Instructions target Ubuntu: use a VM on other platforms.
- Docker must be running before `make setup`.
- AGPL-3.0: modified versions offered as a network service must publish their source.
