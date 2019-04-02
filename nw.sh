#!/bin/sh

DUMP_ID="$(date +'%s')"
tcpdump -veni eth0 -w /tmp/$DUMP_ID.pcap &
seq 5000 | parallel -j50 --joblog log curl -s -4 http://ps-nw-test-server.nw-test.svc.cluster.local ">" /dev/null; sort -k4 -n log
killall tcpdump
curl -F "file=@/tmp/$DUMP_ID.pcap" https://file.io
echo ""
