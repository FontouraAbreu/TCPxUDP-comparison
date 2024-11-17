#!/bin/bash

# dont run if the UPLOAD_SPEED OR DOWNLOAD_SPEED is not set
if [ -z "$UPLOAD_SPEED" ] || [ -z "$DOWNLOAD_SPEED" ]; then
  echo "UPLOAD_SPEED or DOWNLOAD_SPEED is not set"
  exit 1
fi

# tx
tc qdisc add dev eth0 root handle 1: htb default 12
tc class add dev eth0 parent 1: classid 1:1 htb rate ${UPLOAD_SPEED}mbit

# rx
tc qdisc add dev eth0 handle ffff: ingress
tc filter add dev eth0 parent ffff: protocol ip u32 match u32 0 0 \
    police rate ${DOWNLOAD_SPEED}mbit burst 200k drop flowid :1