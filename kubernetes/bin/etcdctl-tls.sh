#!/usr/bin/env bash

if [ -z "${etcd_endpoints}" ];then echo "Please set 'etcd_endpoints' var"; exit 1; fi

filename=etcd

if [ -f ${CERT_DIR:-/etc/kubernetes}/certs/flanneld.pem ];then
  filename=flanneld
fi

ETCDCTL_API=3 etcdctl \
--endpoints=https://${etcd_endpoints}:2379 \
--cacert=${CERT_DIR:-/etc/kubernetes}/certs/ca.pem \
--cert=${CERT_DIR:-/etc/kubernetes}/certs/${filename}.pem \
--key=${CERT_DIR:-/etc/kubernetes}/certs/${filename}-key.pem \
"$@"
