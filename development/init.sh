#!/bin/bash

ls -l /opt/wayland/lib/weston/*.so
ls -l /dev/

weston-launch --help

# --backend=drm-backend.so --use-pixman --tty=/dev/tty
#weston --fullscreen \
#    --backend=fbdev-backend.so --use-gl --tty=/dev/tty

weston-launch -t /dev/tty
