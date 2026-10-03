#!/usr/bin/env bash
# Smoke test for Next Door Key Simulator: two KMEs in Docker, one ETSI 014 key exchange.
set -eu

WORK="${WORK:-$HOME/t51-work}"
REPORT_DIR="$WORK/reports"
mkdir -p "$WORK" "$REPORT_DIR"
cd "$WORK"

if [ ! -d next-door-key-simulator ]
then
  git clone https://github.com/CreepPork/next-door-key-simulator
fi
cd next-door-key-simulator

if [ ! -f certs/sae-1.crt.pem ]
then
  printf '\n' | bash ./certs/generate.sh
fi

docker compose up -d --build
echo "Waiting 60 s for the KMEs to generate keys..."
sleep 60

SAE1=c565d5aa-8670-4446-8471-b0e53e315d2a
SAE2=25840139-0dd4-49ae-ba1e-b86731601803

RESP_A=$(curl -s -k --cert certs/sae-1.crt.pem --key certs/sae-1.key.pem -X POST \
  -H "Content-Type: application/json" -d '{"number":1}' \
  "https://localhost:8010/api/v1/keys/$SAE1/enc_keys")
KEY_ID=$(echo "$RESP_A" | python3 -c 'import sys,json
print(json.load(sys.stdin)["keys"][0]["key_ID"])' 2>/dev/null || echo "")
KEY_A=$(echo "$RESP_A" | python3 -c 'import sys,json
print(json.load(sys.stdin)["keys"][0]["key"])' 2>/dev/null || echo "")

RESP_B=$(curl -s -k --cert certs/sae-2.crt.pem --key certs/sae-2.key.pem -X POST \
  -H "Content-Type: application/json" -d "{\"key_IDs\":[{\"key_ID\":\"$KEY_ID\"}]}" \
  "https://localhost:8020/api/v1/keys/$SAE2/dec_keys")
KEY_B=$(echo "$RESP_B" | python3 -c 'import sys,json
print(json.load(sys.stdin)["keys"][0]["key"])' 2>/dev/null || echo "")

if [ -n "$KEY_A" ] && [ "$KEY_A" = "$KEY_B" ]
then
  RESULT="PASS"
else
  RESULT="FAIL"
fi

REPORT="$REPORT_DIR/next_door_key_simulator_$(date +%Y-%m-%d).md"
cat > "$REPORT" << REP
# Next Door Key Simulator smoke test, $(date +%Y-%m-%d)

- Commit: $(git rev-parse HEAD)
- Platform: $(uname -sm)
- Result: $RESULT
- key_ID: $KEY_ID
- Response KME 1: $RESP_A
- Response KME 2: $RESP_B
REP

docker compose down
echo ""
echo "Result: $RESULT"
echo "Report: $REPORT"
