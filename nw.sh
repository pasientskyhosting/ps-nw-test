#!/bin/sh
seq 5000 | parallel -j50 --joblog log curl -s http://ps-nw-test-server.nw-test.svc.cluster.local ">" /dev/null; sort -k4 -n log
