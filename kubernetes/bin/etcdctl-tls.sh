#!/usr/bin/env bash

if [ -z "${etcd_endpoints}" ];then echo "Please set 'etcd_endpoints' var"; exit 1; fi

filename=etcd

if [ -f ${CERT_DIR:-/opt/k8s}/certs/flanneld-etcd-client.pem ];then
  filename=flanneld-etcd-client
fi

exec etcdctl \
--endpoints=${etcd_endpoints} \
--cacert=${CERT_DIR:-/opt/k8s}/certs/ca.pem \
--cert=${CERT_DIR:-/opt/k8s}/certs/${filename}.pem \
--key=${CERT_DIR:-/opt/k8s}/certs/${filename}-key.pem \
"$@"
