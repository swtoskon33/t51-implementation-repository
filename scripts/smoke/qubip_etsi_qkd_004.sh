#!/usr/bin/env bash
# Smoke test for QUBIP etsi-qkd-004: Alice opens a key stream, Bob joins it, keys are compared.
set -eu

WORK="${WORK:-$HOME/t51-work}"
REPORT_DIR="$WORK/reports"
mkdir -p "$WORK" "$REPORT_DIR"
cd "$WORK"

if [ ! -d etsi-qkd-004 ]
then
  git clone https://github.com/QUBIP/etsi-qkd-004
fi
cd etsi-qkd-004

chmod +x ./certs/generate_certs.sh
if [ ! -d certs ] || [ -z "$(ls certs/*alice* 2>/dev/null)" ]
then
  ./certs/generate_certs.sh qkd_server_alice
  ./certs/generate_certs.sh qkd_server_bob
fi

echo "Building and starting servers (first run downloads a large image)..."
docker compose up --build -d qkd_server_alice qkd_server_bob generate_key_alice generate_key_bob
echo "Waiting 30 s for the emulated link to generate keys..."
sleep 30

ALICE=$(docker compose run --build --rm qkd_client_alice 2>&1)
echo "$ALICE" > "$WORK/qubip_alice.log"
KSID=$(echo "$ALICE" | grep -o 'Key_stream_ID: [^ ,]*' | head -1 | awk '{print $2}')

BOB=$(docker compose run --build --rm -e KEY_STREAM_ID="$KSID" qkd_client_bob 2>&1)
echo "$BOB" > "$WORK/qubip_bob.log"

KEY_A=$(echo "$ALICE" | grep -i 'bytes' | head -2)
KEY_B=$(echo "$BOB" | grep -i 'bytes' | head -2)

if [ -n "$KSID" ] && [ -n "$KEY_A" ] && [ "$KEY_A" = "$KEY_B" ]
then
  RESULT="PASS"
else
  RESULT="CHECK MANUALLY"
fi

REPORT="$REPORT_DIR/qubip_etsi_qkd_004_$(date +%Y-%m-%d).md"
cat > "$REPORT" << REP
# QUBIP etsi-qkd-004 smoke test, $(date +%Y-%m-%d)

- Commit: $(git rev-parse HEAD)
- Platform: $(uname -sm)
- Result: $RESULT
- Key_stream_ID: $KSID
- Alice: $KEY_A
- Bob: $KEY_B
- Full logs: $WORK/qubip_alice.log and $WORK/qubip_bob.log
REP

docker compose down
echo ""
echo "Result: $RESULT"
echo "Report: $REPORT"
