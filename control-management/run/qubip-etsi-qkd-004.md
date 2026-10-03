# QUBIP etsi-qkd-004

**Requirements:** Docker with Compose, OpenSSL. Single workstation.

```bash
git clone https://github.com/QUBIP/etsi-qkd-004 && cd etsi-qkd-004
chmod +x ./certs/generate_certs.sh
./certs/generate_certs.sh qkd_server_alice
./certs/generate_certs.sh qkd_server_bob
docker compose up --build -d qkd_server_alice qkd_server_bob generate_key_alice generate_key_bob
docker compose run --build --rm qkd_client_alice                       # prints Key_stream_ID
docker compose run --build --rm -e KEY_STREAM_ID=<KSID> qkd_client_bob
docker compose run --build --rm qkd_tests_alice
```

## Known issues

- Large base image download on first build.
- Start Docker Desktop first ("Cannot connect to the Docker daemon").
- Bob must reuse Alice's Key_stream_ID.
- Wait about 30 s for the emulated link to generate keys.
- Port 5000 must be free on the host. If it is in use, change the host port in `docker-compose.yml`, for example to `5050:5000`.

## Validation

Tested on 03/10/2026 with Docker Compose. Alice opened a key stream and Bob joined it with the same Key_stream_ID. Result: pass, identical key on both sides.

Commit: `53dfffbf9c03aca1fd8c395d84fbb40681404ef6`
