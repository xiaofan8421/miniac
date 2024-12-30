#!/bin/bash

set -e

function show_basic_info() {
    echo "show_basic_info before..."

    date
    uptime

    # check machine
    hostname -s
    echo "cpu_count: $(nproc)"
    echo "total_memory: $(awk '/MemTotal/ {printf "%.2f", $2/1024}' /proc/meminfo)MB"
    echo "available_memory: $(awk '/MemAvailable/ {printf "%.2f", $2/1024}' /proc/meminfo)MB"
    echo "total_disk: $(df -BG --output=size / | tail -n 1 | tr -d 'G' | xargs)GB"
    echo "available_disk: $(df -BG --output=avail / | tail -n 1 | tr -d 'G' | xargs)GB"

    # check os
    grep -E '^NAME=|^VERSION=' /etc/os-release
    uname -r
    ldd --version | head -n 1
    systemctl --version | head -n 1
    echo "$SHELL"
    df -Th

    echo "show_basic_info after..."
}

show_basic_info