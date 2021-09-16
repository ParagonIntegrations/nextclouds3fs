#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd $parent_path
docker-compose down
rm -R --verbose $parent_path/datadir/nextcloud/bucket/data
docker-compose up -d