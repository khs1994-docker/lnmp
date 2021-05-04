#!/bin/sh

set -ex

env

if [ "$1" = 'bash' ] || [ "$1" = 'sh' ];then exec /bin/sh; fi

# www root
cd /srv/www/coreos

# ipxe

sed -i "s#{{SERVER_HOST}}#${SERVER_HOST}#g" ipxe.html

butane --version ; butane --help || true

cd ignition

rm -rf *.ign *.bu

cp bu/* .
cp ignition-local.example.bu ignition-local.bu

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
  < $item.bu > $item.bu.source

  cp $item.bu.source $item.bu
done

for i in `seq ${NODE_NUM}`;do
  cp ignition-n.master.template.bu ignition-$i.example.bu
  sed -i "s#{{n}}#$i#g" ignition-$i.example.bu
  cp ignition-$i.example.bu ignition-$i.bu

  if ! [ -f ignition-$i.bu ];then
    break
  fi

  echo "handle ignition-$i.bu ...

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
  < ignition-$i.bu > ignition-$i.bu.source

  cp ignition-$i.bu.source ignition-$i.bu

  sed -i "s#{{SSH_PUB}}#${SSH_PUB}#g" ignition-$i.bu
  sed -i "s#{{DISCOVERY_URL}}#${DISCOVERY_URL}#g" ignition-$i.bu
  sed -i "s#{{SERVER_HOST}}#${SERVER_HOST}#g" ignition-$i.bu
  sed -i "s#{{KUBERNETES_VERSION}}#v${KUBERNETES_VERSION}#g" ignition-$i.bu
done

cp ../pxe/pxe-ignition.example.bu ../pxe/pxe-ignition.bu

# replace

for i in `seq ${NODE_NUM}` ; do

  IP=$(echo ${NODE_IPS} | cut -d ',' -f $i)

  if [ -n "$IP" ];then
    sed -i "s/{{IP_$i}}/${IP}/g" $( ls *.bu )
  fi
done

# butane

_butane(){
  echo "butane --strict --pretty "
}

sed -i "s#{{SERVER_HOST}}#${SERVER_HOST}#g" \
  ignition-local.bu \
  basic.bu \
  ../pxe/pxe-ignition.bu

sed -i "s#{{SSH_PUB}}#${SSH_PUB}#g" \
  ignition-local.bu \
  basic.bu \
  ../pxe/pxe-ignition.bu

sed -i "s#{{ETCD_VERSION}}#${ETCD_VERSION}#g" basic.bu

for i in `seq ${NODE_NUM}` ; do

  if [ -f ignition-$i.bu ];then
    $(_butane) ignition-$i.bu > ignition-$i.ign
  fi

done

for item in $MERGE_LIST
do
  sed -i "s#{{SERVER_HOST}}#${SERVER_HOST}#g" $item.bu
  sed -i "s#{{KUBERNETES_VERSION}}#v${KUBERNETES_VERSION}#g" $item.bu
  $(_butane) $item.bu > $item.ign
done

$(_butane) ignition-local.bu > ignition-local.ign
$(_butane) basic.bu > basic.ign

rm -rf *.source

cd ../pxe

$(_butane) pxe-ignition.bu > pxe-config.ign

exec nginx -g "daemon off;"
