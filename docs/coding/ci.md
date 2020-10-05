# 【玩转腾讯云】在 CODING DevOps 持续集成中使用 Buildx 构建 Docker 镜像

现在容器化技术快速发展，Docker 镜像作为其基石，构建镜像的技术也在快速演进，去年 Docker 推出的 [Buildkit](https://github.com/moby/buildkit) 技术试图去解决传统构建镜像过程中所存在的问题：

* 多系统、架构的 Docker 镜像难以统一
* 构建过程难以缓存

为解决以上问题，基于 `buildkit` 的 Docker CLI 插件 [buildx](https://github.com/docker/buildx) 引入了 `--platform` `--cache-from` `--cache-to` 等参数，下面开始介绍如何在 CODING DevOps 持续集成中使用 Buildx 构建 Docker 镜像。

## 登录或者注册 CODING DevOps

* https://cloud.tencent.com/product/coding

## 创建项目

登录之后，点击右上角项目（第三个图标）-> 创建项目 -> 模板选择 **DevOps 项目**

**项目名称**

自己填入一个名称

其他选项可以不填，点击完成创建

## 新建 Dockerfile

选择 **代码仓库** -> **快速初始化仓库** -> 勾选 `启用README.md文件初始化仓库` -> 点击 `快速初始化按钮`

点击 `右上角三个点` -> `新建` -> `文件` -> 输入 `Dockerfile` -> 点击 `创建`

**写入以下内容**

```docker
FROM alpine

RUN set -x \
    && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
    && apk add --no-cache curl git gcc

ARG GIT_COMMIT="unknow"

LABEL org.opencontainers.image.revision=$GIT_COMMIT

CMD ["sh","-c","uname","-a"]
```

**点击提交**

## 启用持续集成

选择 **持续集成** -> `构建计划` -> `创建持续集成任务(新建构建计划配置)` -> 输入 `计划名称` -> 选择 `使用静态配置的 Jenkinsfile` -> 选择 `简易模板` -> 点击 `确定`

001.jpg

CODING DevOps 持续集成使用的是 `Jenkis`，通过 `Jenkinsfile` 进行配置。

点击 `流程配置` -> `文本编辑器` -> 输入以下内容(搜素 `fix me` 替换为自己的内容)-> 点击 `保存`

```json
pipeline {
  agent any
  environment {
    // PLATFORM = "linux/amd64,linux/arm64,linux/arm/v7"
    PLATFORM = "linux/amd64"
    DOCKER_PASSWORD = "${env.DOCKER_PASSWORD}"
    // fix me
    DOCKER_USERNAME = "your_username"
    DOCKER_CLI_EXPERIMENTAL = "enabled"
    BUILDX_IMAGE= "dockerpracticesig/buildkit:master-tencent"
    // fix me 这里使用腾讯云容器服务的 Docker 仓库 https://cloud.tencent.com/product/tke
    DOCKER_REGISTRY= "ccr.ccs.tencentyun.com"
    // fix me
    DOCKER_REPO_NAMESPACE= "your_namespace"
  }
  stages {
    stage('检出') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: env.GIT_BUILD_REF]],
        userRemoteConfigs: [[url: env.GIT_REPO_URL, credentialsId: env.CREDENTIALS_ID]]])
      }
    }
    stage('update docker to latest'){
      steps {
        sh "docker version"
        sh "docker info"

        sh "curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -"
        sh "sudo add-apt-repository \"deb [arch=amd64] https://mirrors.cloud.tencent.com/docker-ce/linux/ubuntu \$(lsb_release -cs) stable\""
        sh "sudo apt update"
        sh "sudo apt install docker-ce docker-ce-cli containerd.io -y"

        sh "docker version"
        sh "docker info"
      }
    }
    stage('setup-buildx'){
      steps {
        sh "docker run --rm --privileged tonistiigi/binfmt:latest --install all | true"
        sh "docker buildx create --use --name mybuilder --driver-opt image=${BUILDX_IMAGE}"
        sh "docker buildx ls"

        sh "docker buildx inspect --bootstrap"
      }
    }
    stage('登录仓库') {
      steps {
        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin ${DOCKER_REGISTRY}"
      }
    }
    stage('构建镜像') {
      steps {
        sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_REPO_NAMESPACE}/demo --build-arg GIT_COMMIT ."

        sh "docker push ${DOCKER_REGISTRY}/${DOCKER_REPO_NAMESPACE}/demo"
      }
    }
    stage('构建镜像-buildx') {
      steps {
        sh "docker buildx build \
            -t ${DOCKER_REGISTRY}/${DOCKER_REPO_NAMESPACE}/demo:buildx \
            --platform linux/amd64 \
            \$(if [ -f '/root/docker_build_cache/index.json' ];then \
                  echo ' --cache-from=type=local,src=/root/docker_build_cache '; \
               fi) \
            --cache-to=type=local,dest=/root/docker_build_cache \
            --build-arg GIT_COMMIT \
            --push ."
      }
    }
  }
}
```

002.jpg

新增 **环境变量**

环境变量可以存储 Docker Registry 密码等私密内容。

选择 `变量与缓存` -> `流程环境变量` -> `添加环境变量`

变量名称 `DOCKER_PASSWORD`，默认值填为你自己的 Docker Registry 密码，勾选 `保密` ->点击确定

003.jpg

设置 **构建缓存**

选择 `变量与缓存` -> `缓存目录` -> 输入 `/root/docker_build_cache` -> 点击 `保存修改`

点击 `返回` -> 点击 `立即构建`

## 查看结果

点击构建列表 -> 在构建过程中点击各个步骤即可查看到构建输出

可以对比 `构建镜像` `构建镜像-buildx` 的执行时间，发现第一次构建两者所用时间相差不大，之后的每次构建 `构建镜像-buildx` 所用的时间较短（30s vs 8s）。

## 结语

免费版本的 CODING DevOps 提供了 `1000分钟/每月` `最多30分钟/次` 的配额。

由于国内访问 Docker Hub 较缓慢，以上用到的 Docker 仓库替换为了腾讯云容器服务提供的 Docker 仓库，创建 `Buildx` 实例的 `Buildkit` 镜像使用了替换镜像源为腾讯云的 `dockerpracticesig/buildkit:master-tencent`。

可以发现使用 `buildx` 构建镜像具有诸多优点，而传统的 Docker 镜像仓库不提供 `buildx` 构建，那么使用 CODING DevOps 构建镜像并推送到仓库中是一个不错的选择。
