# https://hub.docker.com/_/microsoft-powershell?tab=description

FROM mcr.microsoft.com/powershell:preview-alpine-3.11

ENV LWPM_DIST_ONLY='true' \
    LWPM_DOCKER_USERNAME= \
    LWPM_DOCKER_PASSWORD= \
    LWPM_DOCKER_REGISTRY=

RUN apk add --no-cache curl

COPY lnmp-windows-pm-repo  /root/lnmp/windows/lnmp-windows-pm-repo
COPY lnmp-windows-pm.ps1 \
     pwsh-alias.txt        /root/lnmp/windows/
COPY sdk                   /root/lnmp/windows/sdk
COPY powershell_system     /root/lnmp/windows/powershell_system

VOLUME /root/lnmp/vendor

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENTRYPOINT ["pwsh", "-Command", "$ProgressPreference = 'SilentlyContinue'; /root/lnmp/windows/lnmp-windows-pm.ps1"]

CMD ["--help"]
