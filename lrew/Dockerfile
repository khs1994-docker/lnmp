FROM lwpm/lwpm

# ENV LREW_DOCKER_USERNAME=
# ENV LREW_DOCKER_PASSWORD=
# ENV LREW_DOCKER_REGISTRY=

# ENV LREW_DOCKER_NAMESPACE="lrewpkg"

# ENV LREW_PKG_ROOT=

RUN apk add --no-cache git

COPY example /root/lnmp/lrew/example

COPY lrew.ps1 /root/lnmp/lrew/lrew.ps1

WORKDIR /root/lnmp

ENTRYPOINT ["pwsh", "-Command", "$ProgressPreference = 'SilentlyContinue'; /root/lnmp/lrew/lrew.ps1"]

VOLUME ["/root/.khs1994-docker-lnmp"]
