#!/bin/sh

set -ex

env

if [ "$1" = 'bash' ] || [ "$1" = 'sh' ];then
  exec /bin/sh
fi

if ! [ -f /srv/www/coreos/current/version.txt ];then echo "version.txt Not Found /srv/www/coreos/current/version.txt"; exit 1; fi

. /srv/www/coreos/current/version.txt

echo "link current to ${COREOS_VERSION_ID}

"

ln -sf /srv/www/coreos/current /srv/www/coreos/${COREOS_VERSION_ID}

cd /srv/www/coreos

# ipxe

sed -i "s#LOCAL_HOST#${LOCAL_HOST}#g" ipxe.html

ct --help

ct --version

cd disk

cp example/* .

for i in `seq ${NODE_NUM}`;do
  if [ -f ignition-$i.example.yaml ];then
    cp ignition-$i.example.yaml ignition-$i.yaml
  fi

  if [ -f ignition-$i.yaml ];then

    echo "handle ignition-$i.yaml ...

"
    envsubst < ignition-$i.yaml > ignition-$i.yaml.source

    mv ignition-$i.yaml.source ignition-$i.yaml

    sed -i "s#SSH_PUB#${SSH_PUB}#g" ignition-$i.yaml
    sed -i "s#DISCOVERY_URL#${DISCOVERY_URL}#g" ignition-$i.yaml
    sed -i "s#LOCAL_HOST#${LOCAL_HOST}#g" ignition-$i.yaml

  else
    break
  fi
done

cp ../pxe/pxe-ignition.example.yaml ../pxe/pxe-ignition.yaml

cp ignition-test.example.yaml ignition-test.yaml

cp ignition-one.example.yaml ignition-one.yaml

# replace

for i in `seq ${NODE_NUM}` ; do

  IP=$(echo ${NODE_IPS} | cut -d ',' -f $i)

  if ! [ -z $IP ];then
    sed -i "s/IP_$i/${IP}/g" $( ls *.yaml )
  fi
done

# ct

for i in `seq ${NODE_NUM}` ; do

  if [ -f ignition-$i.yaml ];then
    ct -in-file ignition-$i.yaml  > ignition-$i.json
  fi

done

sed -i "s#LOCAL_HOST#${LOCAL_HOST}#g" \
  ignition-one.yaml \
  ignition-test.yaml \
  ../pxe/pxe-ignition.yaml

sed -i "s#SSH_PUB#${SSH_PUB}#g" \
  ignition-one.yaml \
  ignition-test.yaml \
  ../pxe/pxe-ignition.yaml

ct -platform=custom -in-file ignition-test.yaml  > ignition-test.json

ct -in-file ignition-one.yaml  > ignition-one.json

cd ../pxe

ct -in-file pxe-ignition.yaml  > pxe-config.ign

exec nginx -g "daemon off;"
