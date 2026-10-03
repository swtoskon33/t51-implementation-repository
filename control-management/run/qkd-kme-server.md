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

- macOS does not support `.pfx`: point the configs to the bundled `.pem` files with an empty password.
- "Gateway timeout" between KMEs with the bundled self-signed certificates: use `QKD_KME_SERVER_DANGER_INTER_KME_IGNORE_CERT=Y` for local tests only.
- Stale processes keep ports bound: run `pkill qkd_kme_server` before restarting.
