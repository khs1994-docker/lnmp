FROM frolvlad/alpine-glibc:latest@sha256:cd2885e3bcc8776ba359eaadd2359fa916f3dccc8f94fc0b0f6128bd369d4dbb

ENV PROJECT_NAME=docker-compose

ENV DOCKER_COMPOSE_VERSION=1.27.0

ENV URL=https://github.com/docker/compose/releases/download/

ENV TZ=Asia/Shanghai

ARG enc_k

ARG enc_iv

COPY .ssh /root/.ssh

RUN set -x \
      && apk add --no-cache --virtual .build-deps \
               curl \
               openssl \
               git \
               openssh-client \
               tzdata \
      && openssl enc -aes-128-cbc -d -a -in ~/.ssh/ssh.enc -out ~/.ssh/id_rsa \
          -K ${enc_k} \
          -iv ${enc_iv} \
      && echo "StrictHostKeyChecking no" > ~/.ssh/config \
      && echo "UserKnownHostsFile /dev/null" >> ~/.ssh/config \
      && chmod 600 ~/.ssh/id_rsa \
      && git config --global user.name "khs1994-merge-robot" \
      && git config --global user.email "ai@khs1994.com" \
      # 以上为配置 git
      && mkdir -p /${PROJECT_NAME} \
      # 切换到项目目录
      && cd /${PROJECT_NAME} \
      && curl -LO ${URL}${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 \
      # && curl -LO ${URL}${DOCKER_COMPOSE_VERSION}/docker-compose-Darwin-x86_64 \
      # && curl -LO ${URL}${DOCKER_COMPOSE_VERSION}/docker-compose-Windows-x86_64.exe \
      && chmod +x docker-compose-* \
      && ./docker-compose-`uname -s`-`uname -m` --version > version.txt \
      && date > build_date.txt \
      && git init \
      && git status \
      && git add . \
      && COMMIT=`cat version.txt` \
      && git commit -m "${COMMIT}" \
      && git remote add aliyun git@code.aliyun.com:khs1994-docker/compose-cn-mirror.git \
      && git tag -f $DOCKER_COMPOSE_VERSION \
      && git push -f aliyun $DOCKER_COMPOSE_VERSION \
      # 删除敏感数据、依赖
      && apk del .build-deps \
      && rm -rf ~/.ssh .git* .ssh *.sh Dockerfile

FROM alpine
