#!/bin/sh

set -e

if [ -L "/data/resources" ]; then
    unlink /data/resources
fi;

if [ -L "/data/resource-cache" ]; then
    unlink /data/resource-cache
fi;

if [ -f "/data/resources" ] || [ -d "/data/resources" ]; then
    echo "Forbidden file or directory name (resources) in /data volume. Remove or rename it in order to run this container."
    exit 1
fi;

if [ -f "/data/resource-cache" ] || [ -d "/data/resource-cache" ]; then
    echo "Forbidden file or directory name (resource-cache) in /data volume. Remove or rename it in order to run this container."
    exit 1
fi;

if [ ! -f "/data/acl.xml" ]; then
    cp ~/.default/acl.xml /data/acl.xml
fi;

if [ ! -f "/data/mtaserver.conf" ]; then
    cp ~/.default/mtaserver.conf /data/mtaserver.conf
fi;

if [ ! -f "/data/vehiclecolors.conf" ]; then
    cp ~/.default/vehiclecolors.conf /data/vehiclecolors.conf
fi;

if [ -z "$(ls -A /resources)" ]; then
    echo "Downloading latest official resources package..."
    curl "${MTA_DEFAULT_RESOURCES_URL}" -o /tmp/mtasa-resources-latest.zip
    unzip /tmp/mtasa-resources-latest.zip -d /resources
    rm /tmp/mtasa-resources-latest.zip
fi;

if [ -n "$(find /native-modules -maxdepth 1 -name '*.so' -print -quit)" ]; then
    echo "Copying native modules..."
    cp -vf /native-modules/*.so ~/x64/modules
fi;

ln -sf /resources /data/resources
ln -sf /resource-cache /data/resource-cache

./mta-server64 --config "${MTA_SERVER_CONFIG_FILE}" $@
