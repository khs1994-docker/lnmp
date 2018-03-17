# ClusterKit

`ClusterKit` 的目标是使用 Docker 部署 `MySQL` `Redis` `Memcached` 集群。

以下命令均在项目根目录执行，切勿在此目录内执行，随后我们使用命令行测试集群功能。

## 环境说明

### 开发环境

使用 Docker 桌面版（`Docker For Mac` 或者 `Docker For Windows`）。

或者你可能使用的 `Linux` 系统。

总而言之，假设开发环境你只有 **一台机器**。

开发环境中的集群我们都在 **一台机器** 上启动。

### 生产环境

使用 `Swarm mode` 或 `k8s` 部署。

`Mysql` 一个集群。

`Redis` 一个集群。

`Memcached` 一个集群。
