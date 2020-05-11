# https://hub.docker.com/_/microsoft-powershell?tab=description

FROM mcr.microsoft.com/powershell:preview-alpine-3.11

ENV DEST_DOCKER_USERNAME= \
    DEST_DOCKER_PASSWORD= \
    SOURCE_DOCKER_REGISTRY= \
    DEST_DOCKER_REGISTRY= \
    SOURCE_NAMESPACE=library \
    DEST_NAMESPACE=library

RUN apk add --no-cache curl

COPY docker-image-sync.ps1 \
     pwsh-alias.txt        /root/lnmp/windows/
COPY sdk                   /root/lnmp/windows/sdk
COPY powershell_system     /root/lnmp/windows/powershell_system

# SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

SHELL ["pwsh", "-Command", "$ProgressPreference = 'SilentlyContinue';"]

ENTRYPOINT ["pwsh", "-Command", "$ProgressPreference = 'SilentlyContinue'; /root/lnmp/windows/docker-image-sync.ps1"]

CMD ["--help"]
