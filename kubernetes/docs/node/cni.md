# CNI

容器运行时为 `Docker`, 网络由 `Docker` 管理，无需 `CNI`。或者通过 `kubelet` 的 `--network-plugin=cni` 指定网络由 `CNI` 管理。

```bash
plugins.go:166] Loaded network plugin "cni"
docker_service.go:255] Docker cri networking managed by cni
```

容器运行时为其他（例如 `containerd`）,则需要配置 `CNI`

## cniVersion

CNI 配置文件必须设置 `cniVersion`

* `cniVersion` https://github.com/containernetworking/cni/blob/master/SPEC.md
* https://github.com/kubernetes/kubernetes/pull/80482
* https://github.com/coreos/flannel/issues/1173

## 参考

* https://www.jianshu.com/p/a3dc796de936
* https://segmentfault.com/a/1190000017182169
