#!/bin/bash -ue
DEFAULT_PORT=5000
DEFAULT_DECODER="omxh264dec"
DEFAULT_SINK="eglglessink"

: ${PORT=$DEFAULT_PORT}
: ${DECODER=$DEFAULT_DECODER}
: ${SINK=$DEFAULT_SINK}

echo "Receiving video on port ${PORT}"

exec gst-launch-1.0 -v udpsrc port=$PORT ! "application/x-rtp, payload=127" \
  ! rtpjitterbuffer latency=30 ! rtph264depay ! h264parse ! ${DECODER} \
  ! ${SINK} sync=false
