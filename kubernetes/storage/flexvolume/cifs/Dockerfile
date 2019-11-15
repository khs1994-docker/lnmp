FROM busybox

ENV VENDOR=fstab \
    DRIVER=cifs

COPY bin/* /

ENTRYPOINT /bin/sh /deploy.sh
