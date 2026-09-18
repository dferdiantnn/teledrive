#!/bin/sh
set -e

# Support Railway DATABASE_URL
if [ -n "$DATABASE_URL" ] && [ -z "$TELDRIVE_DB_DATA_SOURCE" ]; then
    export TELDRIVE_DB_DATA_SOURCE="$DATABASE_URL"
fi

# Support Railway dynamic PORT
if [ -n "$PORT" ]; then
    export TELDRIVE_SERVER_PORT="$PORT"
fi

echo "Starting Teldrive on port ${TELDRIVE_SERVER_PORT:-8080}..."
exec /usr/local/bin/teldrive run "$@"
