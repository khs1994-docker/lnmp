# SMB

**静态**

* https://github.com/kubernetes-csi/csi-driver-smb

**创建 smb server**

> 如果你拥有 smb 服务端可以省略此步

```bash
$ kubectl apply -k ../../../deploy/smb-server
```

**test**

* https://github.com/kubernetes-csi/csi-driver-smb/blob/master/deploy/example/e2e_usage.md
