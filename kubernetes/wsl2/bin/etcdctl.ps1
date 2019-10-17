. $PSScriptRoot/../.env.example.ps1
. $PSScriptRoot/../.env.ps1

$env:ETCDCTL_API=3

etcdctl `
  --endpoints=${K8S_ETCD_ENTRYPOINTS} `
  --cacert="$PSScriptRoot/../certs/ca.pem" `
  --cert="$PSScriptRoot/../certs/flanneld.pem" `
  --key="$PSScriptRoot/../certs/flanneld-key.pem" `
  $args

if (!$?){
  throw "etcdctl exec error"
}

# member list
