#!/bin/bash


NEXTCLOUD_DATADIR=/opt/s3fs/bucket/data
#NEXTCLOUD_DATADIR=datadir/nextcloud/ssddata/appdata

docker-compose up -d

read -p "Please wait while the nextcloud instance installs and then press enter"

while [ -z "$APPDATADIR" ]; do
    read -p "Please go to the nextcloud web page and create an admin account,
    after the initialization is done come back and press enter"
    APPDATADIR=$(sudo ls $NEXTCLOUD_DATADIR | grep '^appdata_')
done
echo "Appdata directory $APPDATADIR found, continuing."
echo "Setting overwriteprotocol to https"
docker exec --user www-data nextcloud php occ config:system:set overwriteprotocol --value="https"
sleep 1
echo "Copying Appdata files from s3 bucket to internal disk"
sleep 1
sudo cp -a $NEXTCLOUD_DATADIR/$APPDATADIR/. datadir/nextcloud/ssddata/appdata
echo "Copy done: replacing APPDATA_FOLDER environment variable in nextcloud.env"
sleep 1
sed -i "s/^APPDATA_FOLDER=.*/APPDATA_FOLDER=$APPDATADIR/g" nextcloud.env
read -p "Done replacing, press enter to restart the docker environment with the new values"
docker-compose down
docker-compose up -d
read -p "Configuration is done, press enter to exit this script
