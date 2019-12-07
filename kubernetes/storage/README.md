# [Storage](https://kubernetes.io/docs/concepts/storage/)

* https://kubernetes.io/zh/docs/concepts/storage/
* https://github.com/kubernetes/kubernetes/tree/master/pkg/volume

你可以将数据存入以下地方

* [NFS 动态创建 PV](nfs-client)
* [flexvolume-CIFS (SMB, Samba, Windows Share)](flexvolume/cifs)

**静态** 创建 PVC 必须手动创建 PV

**动态** 创建 PVC 会自动创建 PV

```bash
kubernetes.io/aws-ebs
kubernetes.io/azure-disk
kubernetes.io/azure-file
kubernetes.io/cinder
kubernetes.io/gce-pd
kubernetes.io/vsphere-volume
kubernetes.io/empty-dir
kubernetes.io/git-repo
kubernetes.io/host-path
kubernetes.io/nfs
kubernetes.io/secret
kubernetes.io/iscsi
kubernetes.io/glusterfs
kubernetes.io/rbd
kubernetes.io/quobyte
kubernetes.io/cephfs
kubernetes.io/downward-api
kubernetes.io/fc
kubernetes.io/flocker
kubernetes.io/configmap
kubernetes.io/projected
kubernetes.io/portworx-volume
kubernetes.io/scaleio
kubernetes.io/local-volume
kubernetes.io/storageos
kubernetes.io/csi
```
