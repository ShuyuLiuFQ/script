#!/bin/bash
if pgrep -x "gromit-mpx" > /dev/null; then
  gromit-mpx --toggle
else
  gromit-mpx &
  sleep 0.5
  gromit-mpx --toggle
fi
