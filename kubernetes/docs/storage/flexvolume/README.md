# FlexVolume

* https://segmentfault.com/a/1190000020320771
* https://blog.csdn.net/liuliuzi_hz/article/details/74942002

`FlexVolume` 是一个自 1.2 版本（在 `CSI` 之前）以来在 `Kubernetes` 中一直存在的 `out-of-tree` 插件接口。 它使用基于 `exec` 的模型来与驱动程序对接。 用户必须在每个节点（在某些情况下是主节点）上的预定义卷插件路径中安装 `FlexVolume` 驱动程序可执行文件。

`Pod` 通过 `flexvolume` `in-tree` 插件与 `Flexvolume` 驱动程序交互。 更多详情请参考 [这里](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-storage/flexvolume.md)。

## [Out-of-Tree 卷插件](https://kubernetes.io/zh/docs/concepts/storage/volumes/#out-of-tree-%E5%8D%B7%E6%8F%92%E4%BB%B6)

`Out-of-Tree` 卷插件包括容器存储接口（CSI）和 `FlexVolume`。 它们使存储供应商能够创建自定义存储插件，而无需将它们添加到 Kubernetes 代码仓库。

在引入 `CSI` 和 `FlexVolume` 之前，所有卷插件（如上面列出的卷类型）都是 “in-tree” 的，这意味着它们是与 Kubernetes 的核心组件一同构建、链接、编译和交付的，并且这些插件都扩展了 Kubernetes 的核心 API。这意味着向 Kubernetes 添加新的存储系统（卷插件）需要将代码合并到 Kubernetes 核心代码库中。

CSI 和 FlexVolume 都允许独立于 Kubernetes 代码库开发卷插件，并作为扩展部署（安装）在 Kubernetes 集群上。

对于希望创建 out-of-tree 卷插件的存储供应商，请参考这个 [FAQ](https://github.com/kubernetes/community/blob/master/sig-storage/volume-plugin-faq.md)。
