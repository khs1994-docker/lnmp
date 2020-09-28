# [Local](https://kubernetes.io/docs/concepts/storage/volumes/#local)

**静态**

通过 PV 控制器与 Scheduler 的结合，会对 local PV 做针对性的逻辑处理，从而让 Pod 在多次调度时，能够调度到同一个 Node 上。

## 部署

```bash
$ sudo mkdir -p /data/pv
```

```bash
$ kubectl apply -k deploy
```

## 静态提供

自动将 `/mnt/disks` 下的 `local volumes` 作为 `PV`

### 虚拟

```bash
$ mkdir /mnt/disks
$ for vol in vol1 vol2 vol3; do
    sudo mkdir /mnt/disks/$vol
    sudo mount -t tmpfs $vol /mnt/disks/$vol
done
```

### mountPropagation

`mountPropagation: None` 即容器一旦启动，它从宿主机中读到的挂载信息就不变了，即使在宿主机里unmount 了某个目录，容器里对此一无所知。

`mountPropagation: HostToContainer` 如果宿主机的挂载信息发生变动后，挂载信息将能传播到容器里。容器内也会 unmount 相应的目录，从而最终释放对块设备的占用。

`mountPropagation: Bidirectional` 双向的

* https://kuboard.cn/learning/k8s-intermediate/persistent/volume-mount-point.html#%E6%8C%82%E8%BD%BD%E4%BC%A0%E6%92%AD
* https://blog.csdn.net/weixin_33779515/article/details/89542600
* https://cloud.tencent.com/developer/article/1531989

### 报错

```bash
path "/mnt/disks" is mounted on "/" but it is not a shared or slave mount
```

```bash
# 原因参考上一节中的链接

$ sudo mount --make-shared /

# sudo mount --make-slave /

# sudo mount --make-private / (默认)
```

### 验证

`/mnt/disks` 下有三个 `local volumes` `vol1` `vol2` `vol3`

执行 `$ kubectl get pv` 可以看到 `节点数 X 3` 个 PV

```bash
local-pv-b71e07c6        6341Mi     RWO            Delete           Available                                   local-storage            10m
```

在 `/mnt/disks` 下新增 `vol4`(具体步骤见 **虚拟** 一节)，可以看到又自动 **新增** 了一个 `PV`

### 测试

```bash
# 只创建 pod 及 PVC，不要创建 PV
$ kubectl apply -f ./storage/local/tests/pvc.yaml

$ kubectl apply -f ./storage/local/tests/pod.yaml
```

执行后可以看到 `PVC` 绑定到了 **验证** 一节中 `PV`

**删除** 以上创建的 `pod` 以及 `pvc`, `PV` 被删除（内容被清空）,可供使用。

### systemd

```bash
MountFlags=shared
```

## 参考

* https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner
* https://www.jianshu.com/p/8236cb452bcf
* https://www.jianshu.com/p/bfa204cef8c0
* https://stor.51cto.com/art/201812/588905.htm
* https://blog.csdn.net/watermelonbig/article/details/84108424
