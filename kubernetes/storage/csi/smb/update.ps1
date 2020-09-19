$version="v0.3.0"

$items="csi-smb-controller.yaml","csi-smb-driver.yaml","csi-smb-node-windows.yaml","csi-smb-node.yaml","rbac-csi-smb-controller.yaml"

foreach ($item in $items) {
  curl.exe -L https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/master/deploy/${version}/$item -o deploy/$item
}
