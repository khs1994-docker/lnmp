#!/bin/sh

set -ex

env

if [ "$1" = 'bash' ] || [ "$1" = 'sh' ];then
  exec /bin/sh
fi

cd /srv/www/coreos

# ipxe

sed -i "s#{{LOCAL_HOST}}#${LOCAL_HOST}#g" ipxe.html

fcct --version
fcct --help

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

    cp ignition-$i.yaml.source ignition-$i.yaml

    sed -i "s#{{SSH_PUB}}#${SSH_PUB}#g" ignition-$i.yaml
    sed -i "s#{{DISCOVERY_URL}}#${DISCOVERY_URL}#g" ignition-$i.yaml
    sed -i "s#{{LOCAL_HOST}}#${LOCAL_HOST}#g" ignition-$i.yaml

  else
    break
  fi
done

cp ../pxe/pxe-ignition.example.yaml ../pxe/pxe-ignition.yaml

cp ignition-local.example.yaml ignition-local.yaml

# replace

for i in `seq ${NODE_NUM}` ; do

  IP=$(echo ${NODE_IPS} | cut -d ',' -f $i)

  if [ -n "$IP" ];then
    sed -i "s/{{IP_$i}}/${IP}/g" $( ls *.yaml )
  fi
done

# fcct

_fcct(){
  echo "fcct --strict --pretty --input"
}

for i in `seq ${NODE_NUM}` ; do

  if [ -f ignition-$i.yaml ];then
    f$(_fcct) ignition-$i.yaml  > ignition-$i.json
  fi

done

sed -i "s#{{LOCAL_HOST}}#${LOCAL_HOST}#g" \
  ignition-local.yaml \
  basic.yaml \
  merge.yaml \
  ../pxe/pxe-ignition.yaml

sed -i "s#{{SSH_PUB}}#${SSH_PUB}#g" \
  ignition-local.yaml \
  basic.yaml \
  merge.yaml \
  ../pxe/pxe-ignition.yaml

$(_fcct) ignition-local.yaml > ignition-local.json

cd ../pxe

$(_fcct) pxe-ignition.yaml > pxe-config.ign

exec nginx -g "daemon off;"
