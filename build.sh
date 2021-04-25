#!/bin/sh

set -x

# Install dependencies
apt-get update
apt-get install --no-install-recommends -y curl ca-certificates openssl libreadline5 libncursesw5 unzip tzdata

# Install missing libmysqlclient16
curl "https://nightly.mtasa.com/files/modules/64/libmysqlclient.so.16" -o /usr/local/lib/libmysqlclient.so.16

# Install latest MTA server for linux_64
curl "https://linux.mtasa.com/dl/multitheftauto_linux_x64.tar.gz" -o /tmp/multitheftauto_linux_x64.tar.gz
tar -xzvf /tmp/multitheftauto_linux_x64.tar.gz -C /tmp
mkdir /tmp/multitheftauto_linux_x64/x64/modules
mv /tmp/multitheftauto_linux_x64 /srv

# Copy base config files to .default
curl "https://linux.mtasa.com/dl/baseconfig.tar.gz" -o /tmp/baseconfig.tar.gz
tar -xzvf /tmp/baseconfig.tar.gz -C /tmp
mv /tmp/baseconfig /srv/multitheftauto_linux_x64/.default

# Create volume directories
mkdir /data /resources /resource-cache /native-modules
rmdir /srv/multitheftauto_linux_x64/mods/deathmatch
ln -sf /data /srv/multitheftauto_linux_x64/mods/deathmatch

# Add mtaserver user and fix ownership
addgroup --system --gid ${GID} ${USER}
adduser --system --disabled-login --ingroup ${USER} --no-create-home --home /srv/multitheftauto_linux_x64 --gecos "Multi Theft Auto Server" --shell /sbin/nologin --uid ${UID} ${USER}
chown -R ${USER}:${USER} /data /resources /resource-cache /native-modules /srv/multitheftauto_linux_x64

# Cleanup
apt-get clean
rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* 
rm -- "$0"
