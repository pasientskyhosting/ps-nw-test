#!/bin/sh

DUMP_ID="$(date +'%s')"
tcpdump -veni eth0 -w /tmp/$DUMP_ID.pcap &
echo "" > /tmp/output.txt
seq 5000 | parallel -j50 --joblog log -I{} curl -s -4 -w @/curl-format.txt http://ps-nw-test-server.nw-test.svc.cluster.local/{} > /tmp/output.txt; sort -k4 -n log
killall tcpdump
curl -F "file=@/tmp/$DUMP_ID.pcap" https://file.io
curl -F "file=@/tmp/output.txt" https://file.io
echo ""
