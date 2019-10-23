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
          runsc \
          "

set -x

for command in $commands
do
command -v $command && $(echo $command) --help > $command.txt 2>&1 || continue
if [ $command = "containerd" ];then
  containerd config default > $command.conf 2>&1
  continue
fi
done

kube-proxy      --write-config-to ./kube-proxy.config.yaml || true
kube-scheduler  --write-config-to ./kube-scheduler.config.yaml || true
