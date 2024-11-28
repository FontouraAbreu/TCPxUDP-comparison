#!/bin/bash

# dont run if the UPLOAD_SPEED OR DOWNLOAD_SPEED is not set
if [ -z "$NETWORK_SPEED" ]; then
  echo "NETWORK_SPEED is not set"
  exit 1
fi

tc qdisc add dev eth0 root handle 1: htb default 1
tc class add dev eth0 parent 1: classid 1:1 htb rate ${NETWORK_SPEED}mbit burst 15k
tc filter add dev eth0 protocol ip parent 1: prio 1 handle 1: cgroup

IPERF_COMMON_FLAGS="-w 256K -P 10 -t 10 --get-server-output"

IPERF_COMMANDS=(
  "iperf3 -c iperf-server ${IPERF_COMMON_FLAGS} -M 1500 > /volumes/iperf/${NETWORK_SPEED}-1500-tcp.txt 2> /dev/null"
  "iperf3 -c iperf-server ${IPERF_COMMON_FLAGS} -M 9000 > /volumes/iperf/${NETWORK_SPEED}-9000-tcp.txt 2> /dev/null"
  "iperf3 -c iperf-server ${IPERF_COMMON_FLAGS} -M 1500 -u -b ${NETWORK_SPEED}M > /volumes/iperf/${NETWORK_SPEED}-1500-udp.txt 2> /dev/null"
  "iperf3 -c iperf-server ${IPERF_COMMON_FLAGS} -M 9000 -u -b ${NETWORK_SPEED}M > /volumes/iperf/${NETWORK_SPEED}-9000-udp.txt 2> /dev/null"
)

# try to run iperf3 commands until all of them are successful
for i in "${IPERF_COMMANDS[@]}"
do
  while true; do
    echo "Trying to run: $i"
    eval $i
    if [ $? -eq 0 ]; then
      break
    fi
    sleep 5
  done
done