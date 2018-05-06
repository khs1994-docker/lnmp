#
# Quick Start Minikube
#

$global:HYPERV_VIRTUAL_SWITCH='zy'

#
# Thanks Aliyun
#
# @see https://yq.aliyun.com/articles/221687
# @see https://github.com/AliyunContainerService/minikube
#

minikube.exe start `
    --nfs-share=$HOME `
    -v 10 `
    --registry-mirror=https://registry.docker-cn.com `
    --vm-driver="hyperv" `
    --hyperv-virtual-switch ${HYPERV_VIRTUAL_SWITCH} `
    --memory=2048
