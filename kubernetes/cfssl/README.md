# 证书文件和配置文件

* https://kubernetes.io/zh/docs/setup/best-practices/certificates/

```bash
.
|-- apiserver-etcd-client.crt
|-- apiserver-etcd-client.key
|-- apiserver-kubelet-client.crt
|-- apiserver-kubelet-client.key
|-- apiserver.crt
|-- apiserver.key
|-- ca.crt
|-- ca.key
|-- etcd
|   |-- ca.crt
|   |-- ca.key
|   |-- healthcheck-client.crt
|   |-- healthcheck-client.key
|   |-- peer.crt
|   |-- peer.key
|   |-- server.crt
|   `-- server.key
|-- front-proxy-ca.crt
|-- front-proxy-ca.key
|-- front-proxy-client.crt
|-- front-proxy-client.key
|-- sa.key
`-- sa.pub
```
