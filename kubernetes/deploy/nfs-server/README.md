固定集群 IP **10.254.0.49**

需要加载的内核模块

```bash
$ sudo modprobe {nfs,nfsd,rpcsec_gss_krb5} || true
$ sudo modprobe nfsd || true
```
