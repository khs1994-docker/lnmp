# Master 节点高可用

* https://www.cnblogs.com/hahp/p/5803694.html

`controller-manager` 和 `scheduler` 只要加上 `--leader-elect=true` 参数就可以同时启动，系统会自动选举 leader。

`apiserver` 本来就可以多节点同时运行，只要它们连接同一个 `etcd cluster` 就可以了。

## 故障演示

* 删除节点 3
* 新建节点 3

```bash
$ fcos-etcdctl endpoint health

$ fcos-etcdctl member list
881a63738ea17eb1, started, coreos3, https://192.168.57.112:2380, https://192.168.57.112:2379

$ fcos-etcdctl member remove 881a63738ea17eb1

# 必须先添加 member 后启动故障节点 etcd
$ fcos-etcdctl member add coreos3 --peer-urls="https://192.168.57.112:2380"

# 启动故障节点
# 由于默认 etcd 自动启动，我们先将其停止
$ sudo systemctl stop etcd
$ sudo rm -rf /opt/k8s/var/lib/etcd

# 修改 etcd.service 参数

--initial-cluster-state=new 改为 --initial-cluster-state=existing

$ sudo systemctl daemon-reload
$ sudo systemctl start etcd
```
