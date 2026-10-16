#!/bin/sh
set -eu
export ASHFALL_PUBLIC_ORIGIN="${ASHFALL_PUBLIC_ORIGIN:-${RENDER_EXTERNAL_URL:-}}"
exec dotnet /app/host/Ashfall.Preview.Host.dll
