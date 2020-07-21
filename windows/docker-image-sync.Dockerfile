# https://hub.docker.com/_/microsoft-powershell?tab=description

FROM mcr.microsoft.com/powershell:preview-alpine-3.11

# source 仓库的凭证，若为公开仓库则可以不设置
# ENV SOURCE_DOCKER_USERNAME=
# ENV SOURCE_DOCKER_PASSWORD=
# ENV SOURCE_DOCKER_REGISTRY=

# dest 仓库的凭证，必须设置
# ENV DEST_DOCKER_USERNAME=
# ENV DEST_DOCKER_PASSWORD=
# ENV DEST_DOCKER_REGISTRY=

# 是否排除 "s390x", "ppc64le", "386", "mips64le" 架构的镜像，默认为 true 排除
# ENV EXCLUDE_PLATFORM=true
# 是否同步 windows 镜像，默认为 false 不同步
# ENV SYNC_WINDOWS=false

# ENV SOURCE_NAMESPACE=library
# ENV DEST_NAMESPACE=library

RUN apk add --no-cache curl

COPY docker-image-sync.ps1 /root/lnmp/windows/
COPY sdk                   /root/lnmp/windows/sdk
COPY powershell_system     /root/lnmp/windows/powershell_system

# SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

SHELL ["pwsh", "-Command", "$ProgressPreference = 'SilentlyContinue';"]

ENTRYPOINT ["pwsh", "-Command", "$ProgressPreference = 'SilentlyContinue'; /root/lnmp/windows/docker-image-sync.ps1"]

CMD ["--help"]
