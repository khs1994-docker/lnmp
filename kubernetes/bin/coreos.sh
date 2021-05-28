#!/usr/bin/env bash

set -ex

# $ export SERVER_HOST=192.168.57.1
# $ curl http://SERVER_HOST:8080/bin/coreos.sh | NODE_NAME=1 bash

if [ -n "${NODE_NAME}"];then
  NODE_NAME="$1"
fi

FCOS_VERSION=34.20210503.1.0

if [ -z "${NODE_NAME}" ];then
  echo "Please input NODE_NAME

example:

$ ./coreos.sh 1
$ ./coreos.sh 2
$ ./coreos.sh {n}
$ ./coreos.sh basic
$ curl xxx | NODE_NAME=1 bash

"

  exit
fi

IGNITION_FILE_NAME=ignition-${NODE_NAME}.ign

if [ $NODE_NAME = 'basic' ];then IGNITION_FILE_NAME=basic.ign; fi

curl -O http://${SERVER_HOST:-192.168.57.1}:${port:-8080}/ignition/$IGNITION_FILE_NAME

echo "IGNITION_FILE_NAME is $IGNITION_FILE_NAME"

sleep 5

sudo coreos-installer install \
      /dev/sda \
      --stream testing \
      --ignition-file $IGNITION_FILE_NAME \
      --image-url http://${SERVER_HOST:-192.168.57.1}:${port:-8080}/current/fedora-coreos-${FCOS_VERSION}-metal.x86_64.raw.xz
