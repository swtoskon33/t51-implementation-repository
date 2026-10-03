#!/usr/bin/env bash
# Smoke test for qkd_kme_server: two KMEs, one ETSI 014 key exchange.
# Servers run in the background, no extra terminals are needed.
set -eu

WORK="${WORK:-$HOME/t51-work}"
REPORT_DIR="$WORK/reports"
mkdir -p "$WORK" "$REPORT_DIR"
cd "$WORK"

if [ ! -d qkd_kme_server ]
then
  git clone https://github.com/thomasarmel/qkd_kme_server.git
fi
cd qkd_kme_server

echo "Building (first run takes 5-10 minutes)..."
cargo build --release

# macOS cannot read .pfx files, use the bundled .pem files instead
sed -i.bak 's/kme1-to-kme2.pfx/kme1-to-kme2.pem/' config_kme1.json5 config_kme2.json5
sed -i.bak 's/kme2-to-kme1.pfx/kme2-to-kme1.pem/' config_kme1.json5 config_kme2.json5
sed -i.bak 's/"password"/""/' config_kme1.json5 config_kme2.json5

pkill -f "target/release/qkd_kme_server" 2>/dev/null || true
export QKD_KME_SERVER_DANGER_INTER_KME_IGNORE_CERT=Y
target/release/qkd_kme_server config_kme1.json5 > "$WORK/kme1.log" 2>&1 &
PID1=$!
target/release/qkd_kme_server config_kme2.json5 > "$WORK/kme2.log" 2>&1 &
PID2=$!
trap 'kill $PID1 $PID2 2>/dev/null || true' EXIT

echo "Waiting for both KMEs to start..."
sleep 8

RESP_A=$(curl -s -k --cert certs/kme-1-local-zone/client_1.crt --key certs/kme-1-local-zone/client_1.key \
  -X POST -H "Content-Type: application/json" -d '{"number":1}' \
  https://localhost:13000/api/v1/keys/3/enc_keys)
KEY_ID=$(echo "$RESP_A" | python3 -c 'import sys,json
print(json.load(sys.stdin)["keys"][0]["key_ID"])' 2>/dev/null || echo "")
KEY_A=$(echo "$RESP_A" | python3 -c 'import sys,json
print(json.load(sys.stdin)["keys"][0]["key"])' 2>/dev/null || echo "")

RESP_B=$(curl -s -k --cert certs/kme-2-local-zone/client_3.crt --key certs/kme-2-local-zone/client_3.key \
  -X POST -H "Content-Type: application/json" -d "{\"key_IDs\":[{\"key_ID\":\"$KEY_ID\"}]}" \
  https://localhost:14000/api/v1/keys/1/dec_keys)
KEY_B=$(echo "$RESP_B" | python3 -c 'import sys,json
print(json.load(sys.stdin)["keys"][0]["key"])' 2>/dev/null || echo "")

if [ -n "$KEY_A" ] && [ "$KEY_A" = "$KEY_B" ]
then
  RESULT="PASS"
else
  RESULT="FAIL"
fi

REPORT="$REPORT_DIR/qkd_kme_server_$(date +%Y-%m-%d).md"
cat > "$REPORT" << REP
# qkd_kme_server smoke test, $(date +%Y-%m-%d)

- Commit: $(git rev-parse HEAD)
- Platform: $(uname -sm)
- Result: $RESULT
- key_ID: $KEY_ID
- Response KME 1: $RESP_A
- Response KME 2: $RESP_B
REP

echo ""
echo "Result: $RESULT"
echo "Report: $REPORT"
echo "Server logs: $WORK/kme1.log and $WORK/kme2.log"
