#!/usr/bin/env bash

printf "READY\n";

while read line; do
  echo "Processing Event: $line" >&2;
  kill -SIGTERM $PPID
done < /dev/stdin
