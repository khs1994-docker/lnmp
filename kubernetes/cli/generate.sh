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
          runsc \
          "

set -x

for command in $commands
do
  command -v $command && $(echo $command) --help > $command.txt 2>&1 || continue
done

kube-proxy      --write-config-to ./kube-proxy.config.yaml || true
kube-scheduler  --write-config-to ./kube-scheduler.config.yaml || true
