. $PSScriptRoot/../.env.example.ps1
. $PSScriptRoot/../.env.ps1

if ($args[0] -eq 'stop') {
  write-host "==> stop kube-node ..." -ForegroundColor Red
  wsl -d wsl-k8s -u root -- supervisorctl stop kube-node:

  exit
}

Function _mountKubelet($source, $dest) {
  wsl -d wsl-k8s -u root -- bash -c "mountpoint -q $dest"
  if (!$?) {
    wsl -d wsl-k8s -u root -- bash -c "mkdir -p $source $dest"
    Write-Warning "try mount $source to $dest ..."
    wsl -d wsl-k8s -u root -- bash -c "mount --bind $source $dest"
  }
  else {
    Write-Warning "$dest already mount"
  }
}

& $PSScriptRoot/wsl2host --write
& $PSScriptRoot/wsl2host-check

write-host "==> check kube-server $KUBE_APISERVER" -ForegroundColor Green
curl.exe -k --cacert certs/ca.pem $KUBE_APISERVER | out-null

if (!$?) {
  Write-Warning "kube-server $KUBE_APISERVER can't connent, maybe not running"
  Write-Warning "Please up kube-server first!"

  exit 1
}

# check bin file

wsl -d wsl-k8s -- bash -c "ls /wsl/wsl-k8s-data/k8s/bin/kube-containerd > /dev/null 2>&1"

if (!$?) {
  write-host "please install node files, see README.md" -ForegroundColor Red

  exit 1
}

wsl -d wsl-k8s -- bash -c "if ! [ -f /lib/modules/`$(uname -r)/modules.builtin ];then exit 1;fi"

if (!$?) {
  Write-Warning "
==> Default WSL2 kernel not support kube-proxy [ IPVS ] mode, you MUST update WSL2 kernel, please see wsl2/README.KERNEL.md

"

  exit 1
}

wsl -d wsl-k8s -- sh -c "command -v runc > /dev/null 2>&1"

if (!$?) {
  Write-Warning "==> WSL [ runc ] not found, please install docker-ce first on WSL"

  exit 1
}

& $PSScriptRoot/supervisorctl g
& $PSScriptRoot/supervisorctl update
& $PSScriptRoot/../kubelet init

_mountKubelet ${K8S_ROOT}/var/lib/kubelet /var/lib/kubelet
_mountKubelet ${K8S_ROOT}/var/lib/khs1994-docker-lnmp /var/lib/khs1994-docker-lnmp
_mountKubelet ${K8S_ROOT}/opt/cni/bin /opt/k8s/opt/cni/bin
_mountKubelet ${K8S_ROOT}/etc/cni/net.d /opt/k8s/etc/cni/net.d
_mountKubelet ${K8S_ROOT}/usr/libexec/kubernetes/kubelet-plugins /opt/k8s/usr/libexec/kubernetes/kubelet-plugins

wsl -d wsl-k8s -u root -- mount bpffs /sys/fs/bpf -t bpf
wsl -d wsl-k8s -u root -- supervisorctl start kube-node:

Write-Warning "

==> EXEC: ( $ ./wsl2/bin/kubectl-get-csr ), then approve csr

==> if PV is NFS, please up NFS Server first
"
