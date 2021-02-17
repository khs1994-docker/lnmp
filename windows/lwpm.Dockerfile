# https://hub.docker.com/_/microsoft-powershell?tab=description

FROM mcr.microsoft.com/powershell:preview-alpine-3.12

# ENV LWPM_DOCKER_USERNAME=
# ENV LWPM_DOCKER_PASSWORD=
# ENV LWPM_DOCKER_REGISTRY=

# ENV GITHUB_TOKEN=

# ENV LWPM_DOCKER_NAMESPACE="lwpm"

RUN apk add --no-cache curl

COPY lnmp-windows-pm-repo  /root/lnmp/windows/lnmp-windows-pm-repo
COPY lnmp-windows-pm.ps1 \
     docker-image-sync.ps1 /root/lnmp/windows/
COPY sdk                   /root/lnmp/windows/sdk
COPY powershell_system     /root/lnmp/windows/powershell_system

VOLUME /root/lnmp/vendor

# SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

SHELL ["pwsh", "-Command", "$ProgressPreference = 'SilentlyContinue';"]

ENTRYPOINT ["pwsh", "-Command", "$ProgressPreference = 'SilentlyContinue'; /root/lnmp/windows/lnmp-windows-pm.ps1"]

CMD ["--help"]
