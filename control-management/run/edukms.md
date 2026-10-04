# eduKMS

**Requirements:** Docker with Compose 2.20.2 or newer, uv, curl and jq. Single workstation, the three KMS sites run on one host.

## Run

```bash
git clone https://gitlab.com/surfquantum/eduqkd/edukms.git
cd edukms
./tutorial/demo.sh up
./tutorial/demo.sh verify
./tutorial/demo.sh down
```

The demo starts three KMS sites (Amsterdam, Utrecht and Amersfoort). Amsterdam and Amersfoort exchange keys relayed through Utrecht. Successful verification ends with `SUCCESS: the relayed key exchange works.`

Documentation, including the ETSI GS QKD 020 hands-on setup: https://edukms-7437c2.gitlab.io

## Known issues

- At commit `f753c38` the runtime dependency `cryptography` is declared only in a non-runtime dependency group, so the KMS containers stop with `No module named 'cryptography'`. Add `cryptography = "^48.0.0"` to the main dependencies in `pyproject.toml` before running the demo.
- The first run downloads PostgreSQL, RabbitMQ and Valkey images and builds the application, so sufficient free disk space is required.

## Validation

Tested on 04/10/2026 with the three-site demo. The relayed key exchange between Amsterdam and Amersfoort through Utrecht succeeded. The ETSI GS QKD 020 setup has not yet been tested.

Commit: `f753c38`
