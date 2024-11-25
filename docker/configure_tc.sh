#!/bin/bash

# dont run if the UPLOAD_SPEED OR DOWNLOAD_SPEED is not set
if [ -z "$NETWORK_SPEED" ]; then
  echo "NETWORK_SPEED is not set"
  exit 1
fi

tc qdisc add dev eth0 root handle 1: htb default 1
tc class add dev eth0 parent 1: classid 1:1 htb rate ${NETWORK_SPEED}mbit burst 15k
tc filter add dev eth0 protocol ip parent 1: prio 1 handle 1: cgroup

# run the command
exec "$@"