# Next Door Key Simulator

**Requirements:** Docker with Compose, OpenSSL, Bash. Single workstation.

```bash
git clone https://github.com/CreepPork/next-door-key-simulator && cd next-door-key-simulator
bash ./certs/generate.sh
docker compose up -d --build
curl -k --cert certs/sae-1.crt.pem --key certs/sae-1.key.pem -X POST -H "Content-Type: application/json" -d '{"number":1}' https://localhost:8010/api/v1/keys/c565d5aa-8670-4446-8471-b0e53e315d2a/enc_keys
curl -k --cert certs/sae-2.crt.pem --key certs/sae-2.key.pem -X POST -H "Content-Type: application/json" -d '{"key_IDs":[{"key_ID":"<KEY_ID>"}]}' https://localhost:8020/api/v1/keys/25840139-0dd4-49ae-ba1e-b86731601803/dec_keys
```

## Known issues

- Only POST is supported on enc_keys and dec_keys.
- Keys are generated every 30 s.
- SAE identifiers are fixed in `.env`.
