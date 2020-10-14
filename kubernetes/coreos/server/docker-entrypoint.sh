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

rm -rf *.ign *.fcc

cp fcc/* .
cp ignition-local.example.fcc ignition-local.fcc

MERGE_LIST="crictl \
            docker \
            etcd \
            kube-apiserver \
            cri-containerd \
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
            ${ETCD_NODES} \
            ${ETCD_ENDPOINTS} \
            ${KUBE_APISERVER} \
            ${CONTAINER_RUNTIME} \
            ${CONTAINER_RUNTIME_ENDPOINT} \
            ${CONTAINERD_VERSION} \
            ${NETWORK_GATEWAY} \
            ${DEFAULT_GATEWAY} \
           ' \
  < $item.fcc > $item.fcc.source

  cp $item.fcc.source $item.fcc
done

for i in `seq ${NODE_NUM}`;do
  cp ignition-n.master.template.fcc ignition-$i.example.fcc
  sed -i "s#{{n}}#$i#g" ignition-$i.example.fcc
  cp ignition-$i.example.fcc ignition-$i.fcc

  if ! [ -f ignition-$i.fcc ];then
    break
  fi

  echo "handle ignition-$i.fcc ...

"
  envsubst '${K8S_ROOT} \
            ${CRICTL_VERSION} \
            ${ETCD_VERSION} \
            ${ETCD_NODES} \
            ${ETCD_ENDPOINTS} \
            ${KUBE_APISERVER} \
            ${CONTAINER_RUNTIME} \
            ${CONTAINER_RUNTIME_ENDPOINT} \
            ${CONTAINERD_VERSION} \
            ${NETWORK_GATEWAY} \
           ' \
  < ignition-$i.fcc > ignition-$i.fcc.source

  cp ignition-$i.fcc.source ignition-$i.fcc

  sed -i "s#{{SSH_PUB}}#${SSH_PUB}#g" ignition-$i.fcc
  sed -i "s#{{DISCOVERY_URL}}#${DISCOVERY_URL}#g" ignition-$i.fcc
  sed -i "s#{{SERVER_HOST}}#${SERVER_HOST}#g" ignition-$i.fcc
  sed -i "s#{{KUBERNETES_VERSION}}#v${KUBERNETES_VERSION}#g" ignition-$i.fcc
done

cp ../pxe/pxe-ignition.example.fcc ../pxe/pxe-ignition.fcc

# replace

for i in `seq ${NODE_NUM}` ; do

  IP=$(echo ${NODE_IPS} | cut -d ',' -f $i)

  if [ -n "$IP" ];then
    sed -i "s/{{IP_$i}}/${IP}/g" $( ls *.fcc )
  fi
done

# fcct

_fcct(){
  echo "fcct --strict --pretty "
}

sed -i "s#{{SERVER_HOST}}#${SERVER_HOST}#g" \
  ignition-local.fcc \
  basic.fcc \
  ../pxe/pxe-ignition.fcc

sed -i "s#{{SSH_PUB}}#${SSH_PUB}#g" \
  ignition-local.fcc \
  basic.fcc \
  ../pxe/pxe-ignition.fcc

sed -i "s#{{ETCD_VERSION}}#${ETCD_VERSION}#g" basic.fcc

for i in `seq ${NODE_NUM}` ; do

  if [ -f ignition-$i.fcc ];then
    $(_fcct) ignition-$i.fcc > ignition-$i.ign
  fi

done

for item in $MERGE_LIST
do
  sed -i "s#{{SERVER_HOST}}#${SERVER_HOST}#g" $item.fcc
  sed -i "s#{{KUBERNETES_VERSION}}#v${KUBERNETES_VERSION}#g" $item.fcc
  $(_fcct) $item.fcc > $item.ign
done

$(_fcct) ignition-local.fcc > ignition-local.ign
$(_fcct) basic.fcc > basic.ign

rm -rf *.source

cd ../pxe

$(_fcct) pxe-ignition.fcc > pxe-config.ign

exec nginx -g "daemon off;"
