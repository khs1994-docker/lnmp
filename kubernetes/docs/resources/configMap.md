# configMap

## 用途

ConfigMap 可以被用来：

1. 设置环境变量的值

2. 在容器里设置命令行参数

3. 在数据卷里面创建 config 文件

## 更新

更新 `ConfigMap` 后：

* 使用该 `ConfigMap` 挂载的 `Env` **不会** 同步更新
* 使用该 `ConfigMap` 挂载的 `Volume` 中的数据需要一段时间（实测大概10秒）才能同步更新
* 如果使用子路径方式挂载的数据卷，将 **不会** 触发更新。

为了更新容器中使用 `ConfigMap` 挂载的配置，可以通过滚动更新 `pod` 的方式来强制重新挂载 `ConfigMap`，也可以在更新了 `ConfigMap` 后，先将副本数设置为 0，然后再扩容。

## 参考

* https://www.jianshu.com/p/912800b58520
* http://dockone.io/article/8632
* https://www.cnblogs.com/chimeiwangliang/p/8796133.html
