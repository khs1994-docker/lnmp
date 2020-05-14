# https://hub.docker.com/_/microsoft-powershell?tab=description

FROM mcr.microsoft.com/powershell:preview-alpine-3.11

# ENV SOURCE_DOCKER_USERNAME=
# ENV SOURCE_DOCKER_PASSWORD=
# ENV SOURCE_DOCKER_REGISTRY=

# ENV DEST_DOCKER_USERNAME=
# ENV DEST_DOCKER_PASSWORD=
# ENV DEST_DOCKER_REGISTRY=

# ENV EXCLUDE_PLATFORM=true

# ENV SOURCE_NAMESPACE=library
# ENV DEST_NAMESPACE=library

RUN apk add --no-cache curl

COPY docker-image-sync.ps1 \
     pwsh-alias.txt        /root/lnmp/windows/
COPY sdk                   /root/lnmp/windows/sdk
COPY powershell_system     /root/lnmp/windows/powershell_system

# SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

SHELL ["pwsh", "-Command", "$ProgressPreference = 'SilentlyContinue';"]

ENTRYPOINT ["pwsh", "-Command", "$ProgressPreference = 'SilentlyContinue'; /root/lnmp/windows/docker-image-sync.ps1"]

CMD ["--help"]
