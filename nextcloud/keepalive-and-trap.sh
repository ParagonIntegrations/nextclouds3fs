#! /usr/bin/env sh

PERIOD=${1:-10}
DEST=${AWS_S3_MOUNT:-/opt/s3fs/bucket}

exit_script() {
    SIGNAL=$1
    echo "Caught $SIGNAL! Unmounting ${DEST}..."
    fusermount -uz ${DEST}
    s3fs=$(ps -o pid= -o comm= | grep s3fs | sed -E 's/\s*(\d+)\s+.*/\1/g')
    if [ -n "$s3fs" ]; then
        echo "Forwarding $SIGNAL to $s3fs"
        kill -$SIGNAL $s3fs
    fi
    trap - $SIGNAL # clear the trap
    exit $?
}

trap "exit_script SIGHUP" SIGHUP
trap "exit_script SIGINT" SIGINT
trap "exit_script SIGTERM" SIGTERM
trap "exit_script SIGQUIT" SIGQUIT

if [ $UID -gt 0 ]; then
    RUN_AS=$UID
fi

while true; do
    su - $RUN_AS -c "ls $DEST" > /dev/null
    sleep $PERIOD &
    wait $!
done
