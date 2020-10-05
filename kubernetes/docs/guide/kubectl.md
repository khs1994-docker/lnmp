# kubectl

## 增加 hosts

执行 kubectl 的主机必须能 ping 通节点,可以在主机增加 `hosts`

```bash
NODE_IP NODE_NAME
```

否则将不能执行 `exec` `port-forward` 等命令.

* https://www.jianshu.com/p/258539db000a

* https://kubernetes.io/zh/docs/reference/kubectl/overview/
