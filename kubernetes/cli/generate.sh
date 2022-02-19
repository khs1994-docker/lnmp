#!/usr/bin/env bash

commands="kube-apiserver \
          kube-controller-manager \
          kube-scheduler \
          kube-proxy \
          kubelet \
          cri-containerd \
          runc \
          docker \
          dockerd \
          etcd \
          runsc \
          "

set -x

for command in $commands
do
  command -v $command && $(echo $command) --help > $command.txt 2>&1 || continue
done
