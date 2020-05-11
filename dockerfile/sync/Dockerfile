# 必须将此镜像私有

FROM khs1994/docker-image-sync

WORKDIR /root/lnmp/windows/

ARG DEST_DOCKER_REGISTRY
ARG DEST_DOCKER_USERNAME
ARG DEST_DOCKER_PASSWORD
ARG DEST_NAMESPACE

ENV DEST_DOCKER_REGISTRY=$DEST_DOCKER_REGISTRY \
    DEST_DOCKER_USERNAME=$DEST_DOCKER_USERNAME \
    DEST_DOCKER_PASSWORD=$DEST_DOCKER_PASSWORD \
    DEST_NAMESPACE=$DEST_NAMESPACE

ARG CONFIG_URL=https://gitee.com/khs1994-docker/lnmp/raw/19.03/dockerfile/sync/docker-image-sync-by-docker.json

RUN curl -L -o docker-image-sync.json ${CONFIG_URL} \
  ; ./docker-image-sync.ps1

# --build-arg DEST_DOCKER_REGISTRY
# --build-arg DEST_DOCKER_USERNAME
# --build-arg DEST_DOCKER_PASSWORD
# --build-arg DEST_NAMESPACE
