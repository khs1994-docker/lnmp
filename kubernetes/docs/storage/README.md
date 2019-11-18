# Storage

`Out-of-Tree` 卷插件包括容器存储接口（CSI）和 `FlexVolume`。 它们使存储供应商能够创建自定义存储插件，而无需将它们添加到 Kubernetes 代码仓库。

`存储` 可以和 `容器运行时` 做一类比,容器运行时 docker 内置到存储库中,不便于扩展.

存储 [内置](https://kubernetes.io/zh/docs/concepts/storage/volumes/#volume-%E7%9A%84%E7%B1%BB%E5%9E%8B) 了很多卷插件 `aws` `azure` 等(类比 Docker).

`CSI` 和 `FlexVolume` 就是让存储插件放到外部去实现,不要和 k8s 强耦合.(类比 `CRI-O`)

`FlexVolume` 是把可执行文件放到卷插件目录(kubelet --volume-plugin-dir=/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ 参数指定的值),这个可执行文件实现接口.
