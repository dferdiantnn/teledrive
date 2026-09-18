#!/bin/sh
set -e

DB_URL="${DATABASE_URL:-$TELDRIVE_DB_DATA_SOURCE}"
SERVER_PORT="${PORT:-${TELDRIVE_SERVER_PORT:-8080}}"
JWT_SECRET="${TELDRIVE_JWT_SECRET:-$(tr -dc 'a-f0-9' < /dev/urandom | head -c 32)}"
ALLOWED_USERS="${TELDRIVE_JWT_ALLOWED_USERS}"
ENCRYPTION_KEY="${TELDRIVE_TG_UPLOADS_ENCRYPTION_KEY:-$(tr -dc 'a-f0-9' < /dev/urandom | head -c 64)}"
APP_ID="${TELDRIVE_TG_APP_ID:-0}"
APP_HASH="${TELDRIVE_TG_APP_HASH}"

if [ -z "$DB_URL" ]; then
    echo "ERROR: DATABASE_URL or TELDRIVE_DB_DATA_SOURCE is empty!"
    exit 1
fi

cat << TOML > /config.toml
[db]
data-source = "$DB_URL"
prepare-stmt = false

[db.pool]
enable = false

[jwt]
allowed-users = ["$ALLOWED_USERS"]
secret = "$JWT_SECRET"

[tg]
app-id = $APP_ID
app-hash = "$APP_HASH"

[tg.uploads]
encryption-key = "$ENCRYPTION_KEY"

[server]
port = $SERVER_PORT
TOML

echo "=========================================="
echo "Starting Teldrive..."
echo "Port: $SERVER_PORT"
echo "=========================================="

exec /usr/local/bin/teldrive run -c /config.toml "$@"
