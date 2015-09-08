#!/usr/bin/env sh
set -eo pipefail
trap 'echo Received SIGINT, stopping...' SIGINT
trap 'echo Received SIGTERM, stopping...' SIGTERM
trap 'echo Killing background jobs... && jobs -p | xargs -r kill 2>/dev/null' EXIT
eval "$(env | grep _TCP= | sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/socat -ls TCP4-LISTEN:\1,fork,reuseaddr TCP4:\2:\3 \&/')"
wait
