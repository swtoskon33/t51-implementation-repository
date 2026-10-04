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
- The client loads its TLS identity through the native TLS backend, which did not accept the EC P-384 client keys bundled with qkd_kme_server. RSA client certificates with the same serial numbers, signed by the same CA, were used instead.
- The KME server certificate must include the `serverAuth` extended key usage and, for P-384 keys, a SHA-384 signature, otherwise the connection is rejected.

## Validation

Tested on 04/10/2026 against qkd_kme_server with two KMEs. SAE 1 requested a key from KME 1 with `get-keys` and SAE 3 retrieved it from KME 2 with `get-keys-by-ids`. Result: pass, identical key and key_ID on both sides over mutual TLS.
