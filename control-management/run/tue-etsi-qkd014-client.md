# TU/e ETSI-QKD014 client

**Requirements:** Rust toolchain, libsodium. Single workstation and a running ETSI 014 KME.

```bash
sudo apt install libsodium-dev        # macOS: brew install libsodium
git clone https://github.com/TUe-QTS/ETSI-QKD014-client.git
cd ETSI-QKD014-client/binary
cargo install --path .
etsi014-cli --host <kme> --port <port> --key <client.key> --cert <client.crt> --server-ca <ca.crt> --target-sae-id <sae> status
etsi014-cli --host <kme> --port <port> --key <client.key> --cert <client.crt> --server-ca <ca.crt> --target-sae-id <sae> get-keys --amount 1 --key-size 256
```

## Known issues

- SAE identifiers differ between KMEs (numeric, UUID, names).
- Provide the KME CA file explicitly with self-signed test certificates.
