#!/bin/sh

set -ex

env

if [ "$1" = 'bash' ] || [ "$1" = 'sh' ];then exec /bin/sh; fi

# www root
cd /srv/www/coreos

# ipxe

sed -i "s#{{SERVER_HOST}}#${SERVER_HOST}#g" ipxe.html

fcct --version ; fcct --help || true

cd ignition

rm -rf *.json *.yaml

cp example/* .
cp ignition-local.example.yaml ignition-local.yaml

MERGE_LIST="crictl \
            docker \
            etcd \
            flanneld \
            kube-apiserver \
            kube-containerd \
            kube-controller-manager \
            kube-nginx \
            kube-proxy \
            kube-scheduler \
            kubelet \
            merge-common \
            ignition-local \
           "

for item in $MERGE_LIST
do
  envsubst '${K8S_ROOT} \
            ${CRICTL_VERSION} \
            ${ETCD_VERSION} \
            ${FLANNEL_VERSION} \
            ${ETCD_NODES} \
            ${ETCD_ENDPOINTS} \
            ${KUBE_APISERVER} \
            ${CONTAINER_RUNTIME} \
            ${CONTAINER_RUNTIME_ENDPOINT} \
            ${CONTAINERD_VERSION} \
            ${NETWORK_GATEWAY} \
            ${DEFAULT_GATEWAY} \
           ' \
  < $item.yaml > $item.yaml.source

  cp $item.yaml.source $item.yaml
done

for i in `seq ${NODE_NUM}`;do
  cp ignition-n.master.template.yaml ignition-$i.example.yaml
  sed -i "s#{{n}}#$i#g" ignition-$i.example.yaml
  cp ignition-$i.example.yaml ignition-$i.yaml

  if ! [ -f ignition-$i.yaml ];then
    break
  fi

  echo "handle ignition-$i.yaml ...

"
  envsubst '${K8S_ROOT} \
            ${CRICTL_VERSION} \
            ${ETCD_VERSION} \
            ${FLANNEL_VERSION} \
            ${ETCD_NODES} \
            ${ETCD_ENDPOINTS} \
            ${KUBE_APISERVER} \
            ${CONTAINER_RUNTIME} \
            ${CONTAINER_RUNTIME_ENDPOINT} \
            ${CONTAINERD_VERSION} \
            ${NETWORK_GATEWAY} \
           ' \
  < ignition-$i.yaml > ignition-$i.yaml.source

  cp ignition-$i.yaml.source ignition-$i.yaml

  sed -i "s#{{SSH_PUB}}#${SSH_PUB}#g" ignition-$i.yaml
  sed -i "s#{{DISCOVERY_URL}}#${DISCOVERY_URL}#g" ignition-$i.yaml
  sed -i "s#{{SERVER_HOST}}#${SERVER_HOST}#g" ignition-$i.yaml
  sed -i "s#{{KUBERNETES_VERSION}}#v${KUBERNETES_VERSION}#g" ignition-$i.yaml
done

cp ../pxe/pxe-ignition.example.yaml ../pxe/pxe-ignition.yaml

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

sed -i "s#{{SERVER_HOST}}#${SERVER_HOST}#g" \
  ignition-local.yaml \
  basic.yaml \
  ../pxe/pxe-ignition.yaml

sed -i "s#{{SSH_PUB}}#${SSH_PUB}#g" \
  ignition-local.yaml \
  basic.yaml \
  ../pxe/pxe-ignition.yaml

sed -i "s#{{ETCD_VERSION}}#${ETCD_VERSION}#g" basic.yaml

for i in `seq ${NODE_NUM}` ; do

  if [ -f ignition-$i.yaml ];then
    $(_fcct) ignition-$i.yaml --output ignition-$i.json
  fi

done

for item in $MERGE_LIST
do
  sed -i "s#{{SERVER_HOST}}#${SERVER_HOST}#g" $item.yaml
  sed -i "s#{{KUBERNETES_VERSION}}#v${KUBERNETES_VERSION}#g" $item.yaml
  $(_fcct) $item.yaml --output $item.json
done

$(_fcct) ignition-local.yaml --output ignition-local.json
$(_fcct) basic.yaml --output basic.json

rm -rf *.source

cd ../pxe

$(_fcct) pxe-ignition.yaml --output pxe-config.ign

exec nginx -g "daemon off;"
