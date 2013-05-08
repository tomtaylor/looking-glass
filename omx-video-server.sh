#!/bin/bash -ue
DEFAULT_HOST="127.0.0.1"
DEFAULT_PORT=5000
DEFAULT_WIDTH=640
DEFAULT_HEIGHT=480
DEFAULT_FPS=30
DEFAULT_TEXT=`hostname -f`

: ${HOST=$DEFAULT_HOST}
: ${PORT=$DEFAULT_PORT}
: ${WIDTH=$DEFAULT_WIDTH}
: ${HEIGHT=$DEFAULT_HEIGHT}
: ${FPS=$DEFAULT_FPS}
: ${TEXT=$DEFAULT_TEXT}

echo "Serving /dev/video0 at ${WIDTH}x${HEIGHT}px at ${FPS}fps to ${HOST}:${PORT}"

set -x
exec gst-launch-1.0 -v v4l2src device=/dev/video0 \
  ! "video/x-raw,width=${WIDTH},height=${HEIGHT},framerate=${FPS}/1" \
  ! clockoverlay shaded-background=true valignment=bottom halignment=left \
  ! textoverlay shaded-background=true valignment=bottom halignment=right text="${TEXT}" \
  ! omxh264enc ! rtph264pay config-interval=1 \
  ! udpsink host=${HOST} port=${PORT} sync=false
