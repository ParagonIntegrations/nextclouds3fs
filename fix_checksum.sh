#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd $parent_path/datadir
sudo tar czpvf mariadb.tar.gz mariadb
cd $parent_path
export $(cat db.env | xargs) && docker exec -it mariadb mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "UPDATE oc_filecache SET checksum = '' WHERE COALESCE (checksum, '') <> ''" nextcloud