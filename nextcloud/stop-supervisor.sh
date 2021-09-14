#!/usr/bin/env bash

echo "Supervisor started"

while read line; do
  echo "Processing Event: $line" >&2;
  kill -SIGTERM $PPID
done < /dev/stdin
