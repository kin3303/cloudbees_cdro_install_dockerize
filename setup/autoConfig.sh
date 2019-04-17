
docker exec $(docker ps |grep commanderserver_1|awk '{print $1}')   /tmp/scripts/import_license_and_create_resource.sh
