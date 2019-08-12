#!/usr/bin/env bash

set -ex

# $ curl http://LOCAL_HOST:8080/disk/bin/coreos.sh > coreos.sh
# $ LOCAL_HOST=192.168.57.1 sh coreos.sh 1

if [ -n "$NODE_NAME"];then
  NODE_NAME="$1"
fi

FCOS_VERSION=30.20190801.0

if [ -z $NODE_NAME ];then
  echo "Please input NODE_NAME

example:

$ ./coreos.sh 1

"

  exit
fi

curl -O http://${LOCAL_HOST:-192.168.57.1}:${port:-8080}/disk/ignition-${NODE_NAME}.json

sudo /usr/libexec/coreos-installer \
      -d /dev/sda \
      -i ignition-${NODE_NAME}.json \
      -b http://${LOCAL_HOST:-192.168.57.1}:${port:-8080}/current/fedora-coreos-${FCOS_VERSION}-metal.raw.xz
