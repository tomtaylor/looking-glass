#!/bin/bash -ue
DEFAULT_PORT=5000
: ${PORT=$DEFAULT_PORT}

echo "Receiving video on port ${PORT}"

exec gst-launch-1.0 -v udpsrc port=$PORT ! "application/x-rtp, payload=127" \
  ! rtph264depay ! h264parse ! omxh264dec ! eglglessink sync=false
