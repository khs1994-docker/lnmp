#!/usr/bin/env bash

ETCDCTL_API=3 etcdctl \
--endpoints=https://${etcd_endpoints}:2379 \
--cacert=${CERT_DIR:-/etc/kubernetes}/certs/ca.pem \
--cert=${CERT_DIR:-/etc/kubernetes}/certs/etcd.pem \
--key=${CERT_DIR:-/etc/kubernetes}/certs/etcd-key.pem \
"$@"
