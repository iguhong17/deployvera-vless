#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:-}"
if [ -z "$UUID" ]; then
  echo "error: UUID env var is required" >&2
  exit 1
fi
WS_PATH="${WS_PATH:-/vless}"
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": ${PORT},
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "${UUID}"}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "${WS_PATH}"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom"}]
}
EOF
exec /usr/local/bin/xray run -config /etc/xray/config.json
