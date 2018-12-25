# Master 节点高可用

* https://www.cnblogs.com/hahp/p/5803694.html

`controller-manager` 和 `scheduler` 只要加上 `--leader-elect=true` 参数就可以同时启动，系统会自动选举 leader。

`apiserver` 本来就可以多节点同时运行，只要它们连接同一个 `etcd cluster` 就可以了。
