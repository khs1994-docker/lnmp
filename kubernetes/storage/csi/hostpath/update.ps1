$VERSION="1.18"

$items="csi-hostpath-attacher.yaml",`
"csi-hostpath-driverinfo.yaml",`
"csi-hostpath-plugin.yaml",`
"csi-hostpath-provisioner.yaml",`
"csi-hostpath-resizer.yaml",`
"csi-hostpath-snapshotter.yaml"

foreach($item in $items){
  curl.exe `
  -L `
  -o deploy/$item `
  https://raw.githubusercontent.com/kubernetes-csi/csi-driver-host-path/master/deploy/kubernetes-${VERSION}/hostpath/$item
}
