#!/usr/bin/env bash

commands="kube-apiserver \
          kube-controller-manager \
          kube-scheduler \
          kube-proxy \
          kubelet \
          containerd \
          runc \
          docker \
          dockerd \
          etcd \
          flanneld \
          "

set -x

for command in $commands
do
command -v $command && $(echo $command) --help > $command.txt 2>&1
done
