cd datadir
sudo tar czpvf mariadb.tar.gz mariadb
mysql -u root -p -e "UPDATE oc_filecache SET checksum = '' WHERE COALESCE (checksum, '') <> ''" nextcloud