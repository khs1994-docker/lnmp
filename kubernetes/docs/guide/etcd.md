# Etcd

## 端口

* `2380` 和集群中其他节点通信
* `2379` 提供 HTTP(S) API 服务，供客户端交互

## 配置

* `--listen-peer-urls` 和成员之间通信的地址
* `--listen-client-urls` 对外提供服务的地址

### 集群相关配置

* `--advertise-client-urls` 此成员的客户端URL列表，用于通告群集的其余部分。这些URL可以包含域名
* `--initial-advertise-peer-urls` 该节点成员对等URL地址，且会通告群集的其余成员节点

* `--initial-advertise-peer-urls` `--initial-cluster` `--initial-cluster-state` `--initial-cluster-token` 标识用于引导一个新成员，当重启一个已经存在的成员时将忽略

## 参考

* https://www.cnblogs.com/itzgr/p/9920910.html
