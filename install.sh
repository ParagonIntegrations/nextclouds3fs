#!/bin/bash

#docker exec --user www-data nextcloud php occ config:system:set overwriteprotocol --value="https"

rm -R datadir
mkdir -p  datadir/nextcloud/bucket