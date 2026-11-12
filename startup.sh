#!/bin/sh
# Revive the 2801-R1 studio viewer. Idempotent. The mission sim stays at /index.html.
cd /workspace/shackleton || exit 1
if curl -sf -o /dev/null --max-time 1 http://127.0.0.1:8080/; then
  exit 0
fi
if [ ! -d node_modules/three ]; then
  npm install
fi
ROVER_PREVIEW=1 npm run dev -- --host 0.0.0.0 --port 8080 --strictPort > /tmp/rover-dev.log 2>&1 &
i=0
while [ "$i" -lt 40 ]; do
  if curl -sf -o /dev/null --max-time 1 http://127.0.0.1:8080/; then
    exit 0
  fi
  i=$((i + 1))
  sleep 0.4
done
echo "rover preview did not come up" >&2
tail -n 40 /tmp/rover-dev.log >&2
exit 1
