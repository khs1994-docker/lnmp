# cGroupv2

* https://github.com/torvalds/linux/blob/master/Documentation/admin-guide/cgroup-v2.rst
* https://blog.csdn.net/juS3Ve/article/details/78769197
* https://blog.csdn.net/sinat_20184565/article/details/98475824
* https://hustcat.github.io/cgroup-v2-and-writeback-support/
* https://my.oschina.net/u/1262062/blog/2051159
* https://docs.docker.com/config/containers/resource_constraints/
* http://www.jinbuguo.com/systemd/systemd.html#systemd.unified_cgroup_hierarchy
* https://www.redhat.com/sysadmin/fedora-31-control-group-v2
* https://facebookmicrosites.github.io/cgroup2/
* https://wiki.archlinux.org/index.php?title=Cgroups&oldid=596909
* https://www.lijiaocn.com/%E6%8A%80%E5%B7%A7/2019/01/28/linux-tool-cgroup-detail.html

## Fedora 31+ 恢复到 cGroupv1

> 在 Fedora 31+ 中使用 Docker **必须** 恢复到 cGroupv1

* https://www.linuxprobe.com/fedora-30-shell.html

```bash
$ sudo dnf install grubby

$ sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"

# 恢复到 cGroupv2
# $ sudo grubby --update-kernel=ALL --remove-args="systemd.unified_cgroup_hierarchy=0"
```

* https://github.com/docker/for-linux/issues/665

## 禁用 cGroup 1

添加内核参数 `cgroup_no_v1=all`

## cGroupv1 介绍

cgroupv2 实现的 controller 是 cgroupv1 的子集，可以同时使用 cgroupv1 和 cgroupv2，但一个 controller 不能既在 cgroupv1 中使用，又在 cgroupv2 中使用

* `cgroup` 关联一组 task 和一组 subsystem 的配置参数。一个 task 对应一个进程, cgroup 是资源分片的最小单位。
* `subsystem` 资源管理器，一个 subsystem 对应一项资源的管理，如 cpu, cpuset, memory 等
* `hierarchy` 关联一个到多个 subsystem 和一组树形结构的 cgroup. 和 cgroup 不同，hierarchy 包含的是可管理的 subsystem 而非具体参数

**规则**

* 一个 hierarchy 可以有一个或多个 subsystem

```bash
$ mount -t cgroup -o cpu,cpuset,memory cpu_and_mem /sys/fs/cgroup/cpu_and_mem
```

* 一个已经被挂载的 subsystem 只能被再次挂载在一个空的 hierarchy 上 (已经 mount 一个 subsystem 的 hierarchy 不能挂载一个已经被其它 hierarchy 挂载的 subsystem)。一个 subsystem 不能挂载到一个已经挂载了不同 subsystem 的 hierarchy 上。

* subsystem 相同的 hierarchy 是被重复使用的。

* 当创建一个新的 hierarchy 时，如果使用的 subsystem 被其他 hierarchy 使用，则会返回 EBUSY 错误。如 /sys/fs/cgroup 中已经在 cpuset 和 memory 中单独使用了名为 cpuset 和 memory 的 subsystem，则重新创建一个包含了它们的 hierarchy 会返回错误。

```bash
$ mount -t cgroup -o cpuset,memory mem1 cgrp1/
mount: mem1 is already mounted or /cgroup/cgrp1 busy
```

* 每个 task 只能在同一个 hierarchy 的唯一一个 cgroup 里(不能在同一个 hierarchy 下有超过一个 cgroup 的tasks 里同时有这个进程的 pid)。在 hierarchy memory 中创建 2 个 cgroup mem1 和 mem2，可以看到将当前 bash 进程写入到 mem2/tasks 之后，mem1/tasks 中的内容就会被清空。

* 子进程在被 fork 出时自动继承父进程所在 cgroup，但是 fork 之后就可以按需调整到其他 cgroup

## 参数

* `cpu.cfs_period_us` cpu 分配的周期(微秒），默认为 `100000`
* `cpu.cfs_quota_us` 表示该 control group 限制占用的时间（微秒），默认为 -1，表示不限制。如果设为`50000`，表示占用 `50000/100000=50%` 的 CPU。对于单核来说，最大等于 cpu.cfs_period_us 的值，对于多核来说，可以理解为最多可使用的 cpu 核数（4 核使用 2 核 `200000`）

## 子系统 subsystems

* https://github.com/torvalds/linux/tree/master/Documentation/admin-guide/cgroup-v1

* `blkio` 子系统，可以限制进程的块设备 io。
* `cpu` 子系统，主要限制进程的 cpu 使用率。
* `cpuacct` 子系统，可以统计 cgroups 中的进程的 cpu 使用报告。
* `cpuset` 子系统，可以为 cgroups 中的进程分配单独的 cpu 节点或者内存节点。
* `devices` 子系统，可以控制进程能够访问某些设备。
* `freezer` 子系统，可以挂起或者恢复 cgroups 中的进程。
* `hugetlb` 这个子系统主要针对于HugeTLB系统进行限制，这是一个大页文件系统。
* `memory` 子系统，可以限制进程的 memory 使用量。
* `net_cls` 子系统，可以标记 cgroups 中进程的网络数据包，然后可以使用 tc 模块（traffic control）对数据包进行控制。
* `net_prio` 这个子系统用来设计网络流量的优先级
* `pids`
* `rdma`

## 手动挂载

```bash
/cgroup/
├── blkio                             <--------------- hierarchy/root cgroup
│   ├── blkio.io_merged               <--------------- subsystem parameter
... ...
│   ├── blkio.weight
│   ├── blkio.weight_device
│   ├── cgroup.event_control
│   ├── cgroup.procs
│   ├── lxc                          <--------------- cgroup
│   │   ├── blkio.io_merged          <--------------- subsystem parameter
│   │   ├── blkio.io_queued
... ... ...
│   │   └── tasks                    <--------------- task list
│   ├── notify_on_release
│   ├── release_agent
│   └── tasks
...

```

```bash
$ mount -t tmpfs cgroup_root /sys/fs/cgroup
$ mkdir /sys/fs/cgroup/cpuset
$ mount -t cgroup cpuset -ocpuset /sys/fs/cgroup/cpuset
```

**实践**

```bash
# 查看挂载点
$ mount -t cgroup

$ cd /sys/fs/cgroup/cpu

$ mkdir cpu_test
```

```c
int main(void)
{
    int i = 0;
    for(;;) i++;
    return 0;
}
```

编译该 C 程序并运行

```bash
$ gcc test.c

$ ./a.out
```

```bash
$ top
# 该程序占用 cpu 100%

# 默认-1不限制，现在改成20000，可以理解使用率限制在20%
$ echo 20000 > /sys/fs/cgroup/cpu/cpu_test/cpu.cfs_quota_us
# 查看程序 PID
$ echo 23732 > /sys/fs/cgroup/cpu/cpu_test/tasks
# 再次执行 top，可以看到 cpu 占用降到 20%
```

## cGroupv2

```bash
$ mount -t cgroup2 none $MOUNT_POINT

$ echo "+memory" > /sys/fs/cgroup2/cgroup.subtree_control
```
