#!/bin/bash


NEXTCLOUD_DATADIR=datadir/nextcloud/bucket/data

docker-compose up -d

read -p "Please wait while the nextcloud instance installs and then press enter"

while [ -z "$APPDATADIR" ]; do
    read -p "Please go to the nextcloud web page and create an admin account, after the initialization is done come\
back and press enter. If you get a message about untrusted domains type y " UNTRUSTED
    if [ "$UNTRUSTED" == "y" ]; then
        read -p "Please enter your domain name like: test.example.com " DOMAIN
        docker exec --user www-data nextcloud php occ config:system:set trusted_domains 2 --value="$DOMAIN"
    fi
    APPDATADIR=$(sudo ls $NEXTCLOUD_DATADIR | grep '^appdata_')
done
echo "Appdata directory $APPDATADIR found, continuing"
echo "Setting overwriteprotocol to https"
docker exec --user www-data nextcloud php occ config:system:set overwriteprotocol --value="https"
sleep 1
echo "Copying Appdata files from s3 bucket to internal disk"
sleep 1
sudo cp --verbose -a $NEXTCLOUD_DATADIR/$APPDATADIR/. datadir/nextcloud/ssddata/appdata
echo "Copy done: removing files from s3 bucket."
sudo rm --verbose -r $NEXTCLOUD_DATADIR/$APPDATADIR/*
echo "Removing done: replacing APPDATA_FOLDER environment variable in nextcloud.env"
sleep 1
sed -i "s/^APPDATA_FOLDER=.*/APPDATA_FOLDER=$APPDATADIR/g" nextcloud.env
read -p "Done replacing, press enter to restart the docker environment with the new values"
docker-compose down
docker-compose up -d
read -p "Configuration is done, press enter to exit this script"
