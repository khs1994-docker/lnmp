#!/usr/bin/env bash

ETCDCTL_API=3 etcdctl \
--endpoints=https://${etcd_endpoints}:2379 \
--cacert=/etc/kubernetes/certs/ca.pem \
--cert=/etc/kubernetes/certs/etcd.pem \
--key=/etc/kubernetes/certs/etcd-key.pem \
"$@"
