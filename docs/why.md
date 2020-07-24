# 项目初衷

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## 前言

搭建一个 LNMP 环境需要手动下载 LNMP 源码包，安装依赖包，编译，编译出错再安装依赖包，再修改默认配置，这样一个过程差不多半天过去了。

Docker 的优点是轻量、跨平台、提供一致的环境，避免「在我这里行换到你那就不行的问题」，笔者之前一直使用 `docker run` 来使用 Docker，问题是启动一个容器需要写参数、环境变量、挂载文件目录等，造成命令的繁杂，不易读，之后就将 `docker run ...` 写入脚本文件，通过运行脚本文件来启动Docker。

接触 Docker Compose 之后把原来的启动命令写成 `docker-compose.yml` 来使用 Docker。Docker Compose 是一种容器编排工具，也就是管理多个容器的工具，以启动 LNMP（包括 Redis ） 为例，使用 `docker run` 你需要执行四条命令，而使用 Docker Compose 你只需执行 `docker-compose up -d` 就把四个容器全部启动了。

## 项目目标

综上，本项目的目标是让 PHP 开发者快速（一键）搭建基于容器技术（Docker、Kubernetes）的开发、测试、生产（CI/CD）环境。

支持 `Linux` `macOS` `Windows` `WSL` `WSL2` 等平台，并提供一系列 CLI (`lnmp-*`) 方便开发者管理开发工具（安装、启动、停止、执行命令）。

提供 [`lrew`](lrew.md) 包管理工具扩展本项目。

提供 [`lwpm`](windows/lwpm.md) Windows 包管理工具安装 Windows 软件。
