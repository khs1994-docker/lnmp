## [CSI](https://kubernetes.io/zh/docs/concepts/storage/volumes/#csi)

* https://github.com/kubernetes-csi
* https://kubernetes-csi.github.io/docs/drivers.html

* https://blog.csdn.net/yevvzi/article/details/79561167

从 `1.8` 版开始，`Kubernetes Storage SIG` 停止接受树内卷插件，并建议所有存储提供商实施树外插件。目前有两种推荐的实现方式：容器存储接口（CSI）和 `Flexvolume`。
