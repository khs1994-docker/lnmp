#!/usr/bin/env bash

set -ex

# $ curl http://LOCAL_HOST:8080/disk/bin/coreos.sh > coreos.sh
# $ LOCAL_HOST=192.168.57.1 sh coreos.sh 1

node_name="$1"

if [ -z $node_name ];then
  echo "Please input node_name
  
example:

$ ./coreos.sh 1

"

  exit
fi

curl -O http://${LOCAL_HOST:-192.168.57.1}:${port:-8080}/disk/ignition-${node_name}.json

sudo coreos-install \
      -d /dev/sda \
      -C alpha \
      -i ignition-${node_name}.json \
      -b http://${LOCAL_HOST:-192.168.57.1}:${port:-8080} \
      -v
      