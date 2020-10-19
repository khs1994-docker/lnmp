FROM khs1994/docker-image-sync

WORKDIR /root/lnmp/windows/

ARG DEST_DOCKER_REGISTRY=registry.cn-beijing.aliyuncs.com
ARG DEST_DOCKER_USERNAME=906210846@qq.com
ARG DEST_DOCKER_PASSWORD=fix_me
ARG DEST_NAMESPACE=khs1994
# fix me 必须替换为自己的配置文件
# ARG CONFIG_URL=https://gitee.com/khs1994-docker/lnmp/raw/20.10/dockerfile/sync/docker-image-sync-by-docker.json
ARG CONFIG_URL=https://github.com/khs1994-docker/lnmp/raw/20.10/dockerfile/php/sync/docker-image-sync.json

# ARG SOURCE_DOCKER_REGISTRY=registry-1.docker.io
# ARG SOURCE_DOCKER_REGISTRY=hub-mirror.c.163.com
ARG SOURCE_DOCKER_REGISTRY=registry.us-east-1.aliyuncs.com

ENV DEST_DOCKER_REGISTRY=$DEST_DOCKER_REGISTRY
ENV DEST_DOCKER_USERNAME=$DEST_DOCKER_USERNAME
ENV DEST_DOCKER_PASSWORD=$DEST_DOCKER_PASSWORD
ENV DEST_NAMESPACE=$DEST_NAMESPACE
ENV CONFIG_URL=$CONFIG_URL
ENV SOURCE_DOCKER_REGISTRY=$SOURCE_DOCKER_REGISTRY
# 更多环境变量请查看 https://github.com/khs1994-docker/lnmp/blob/master/windows/docker-image-sync.Dockerfile

ENV SOURCE_NAMESPACE=khs1994-us

RUN ./docker-image-sync.ps1 \
  ; rm -rf /root/.khs1994-docker-lnmp

# --build-arg DEST_DOCKER_REGISTRY
# --build-arg DEST_DOCKER_USERNAME
# --build-arg DEST_DOCKER_PASSWORD
# --build-arg DEST_NAMESPACE
# --build-arg CONFIG_URL
