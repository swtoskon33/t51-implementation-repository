# qkd_kme_server

**Requirements:** Rust toolchain, OpenSSL. Single workstation. Real QKD link only for operational use.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
git clone https://github.com/thomasarmel/qkd_kme_server.git && cd qkd_kme_server
cargo build --release
# terminal 1
QKD_KME_SERVER_DANGER_INTER_KME_IGNORE_CERT=Y target/release/qkd_kme_server config_kme1.json5
# terminal 2
QKD_KME_SERVER_DANGER_INTER_KME_IGNORE_CERT=Y target/release/qkd_kme_server config_kme2.json5
# terminal 3: SAE 1 requests a key, SAE 3 retrieves it
curl -k --cert certs/kme-1-local-zone/client_1.crt --key certs/kme-1-local-zone/client_1.key -X POST -H "Content-Type: application/json" -d '{"number":1}' https://localhost:13000/api/v1/keys/3/enc_keys
curl -k --cert certs/kme-2-local-zone/client_3.crt --key certs/kme-2-local-zone/client_3.key -X POST -H "Content-Type: application/json" -d '{"key_IDs":[{"key_ID":"<KEY_ID>"}]}' https://localhost:14000/api/v1/keys/1/dec_keys
```

## Known issues

- If the `.pfx` client certificates cannot be loaded, point the configurations to the bundled `.pem` files with an empty password.
- "Gateway timeout" between KMEs with the bundled self-signed certificates: use `QKD_KME_SERVER_DANGER_INTER_KME_IGNORE_CERT=Y` for local tests only.
- Stale processes keep ports bound: run `pkill qkd_kme_server` before restarting.
- The bundled test certificates lack the `serverAuth` extended key usage and sign P-384 keys with SHA-256, which strict TLS clients reject. Reissuing the server certificates with the same CA, `serverAuth` and SHA-384 resolves this.

## Validation

Tested on 29/09/2026 with two KMEs on one host. SAE 1 requested a key from KME 1 and SAE 3 retrieved it from KME 2. Result: pass, identical key and key_ID on both sides over mutual TLS.

Commit: `0ddf603841036faaa1ccbd32c12e2464afa64430`
