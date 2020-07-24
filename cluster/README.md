# ClusterKit

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

`ClusterKit` 的目标是使用 Docker 部署 `MySQL` `Redis` `Memcached` 集群。

以下命令均在项目根目录执行，切勿在此目录内执行，随后我们使用命令行测试集群功能。

## 环境说明

### 开发环境

使用 Docker 桌面版 `Docker Desktop`。

或者你可能使用的 `Linux` 系统。

总而言之，假设开发环境你只有 **一台机器**。

开发环境中的集群我们都在 **一台机器** 上启动。

### 生产环境

使用 `Swarm mode` 或 `k8s` 部署。

`Mysql` 一个集群。

`Redis` 一个集群。

`Memcached` 一个集群。
