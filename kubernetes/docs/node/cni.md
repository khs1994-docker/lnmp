# CNI

* https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/

容器运行时为 `Docker`, 网络由 `Docker` 管理，无需 `CNI`。或者通过 `kubelet` 的 `--network-plugin=cni` 指定网络由 `CNI` 管理。

```bash
plugins.go:166] Loaded network plugin "cni"
docker_service.go:255] Docker cri networking managed by cni
```

容器运行时为其他（例如 `containerd`）,则需要配置 `CNI`

kubelet 参数（仅 Docker 运行时有效）

**cni-bin-dir** Kubelet probes this directory for plugins on startup

**network-plugin** The network plugin to use from **cni-bin-dir**. It must match the name reported by a plugin probed from the plugin directory. For CNI plugins, this is simply **cni**

If there are multiple CNI configuration files in the directory, the kubelet uses the configuration file that comes first by name in lexicographic order.

**--network-plugin=cni** specifies that we use the cni network plugin with actual CNI plugin binaries located in **--cni-bin-dir (default /opt/cni/bin)** and CNI plugin configuration located in **--cni-conf-dir (default /etc/cni/net.d)**.

**--network-plugin=kubenet** specifies that we use the kubenet network plugin with CNI bridge and host-local plugins placed in **/opt/cni/bin** or **cni-bin-dir**.

**--network-plugin-mtu=9001** specifies the MTU to use, currently only used by the **kubenet** network plugin.

## cniVersion

CNI 配置文件必须设置 `cniVersion`

* `cniVersion` https://github.com/containernetworking/cni/blob/master/SPEC.md
* https://github.com/kubernetes/kubernetes/pull/80482

## 参考

* https://segmentfault.com/a/1190000017182169
