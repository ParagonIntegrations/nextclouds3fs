#! /usr/bin/env sh

echo "Empty.sh started"
DEST=${AWS_S3_MOUNT:-/opt/s3fs/bucket}
. trap.sh

#tail -f /dev/null
sleep 600