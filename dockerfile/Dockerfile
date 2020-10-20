# https://docs.docker.com/engine/reference/builder/

ARG VERSION=1.0.0

FROM A:${VERSION} as builder

SHELL ["powershell", "-command"]

RUN echo

FROM B

ARG <name>[=<default value>]

LABEL <key>=<value> <key>=<value> <key>=<value> ...

COPY --from=builder /src/path /target/path

COPY --from=builder /file /file2 /target/path/

ENV <key>=<value> ...

USER <user>[:<group>]

USER <UID>[:<GID>]

ADD --chown=55:mygroup files* /somedir/

COPY [--chown=<user>:<group>] <src>... <dest>

EXPOSE <port> [<port>/<protocol>...]

VOLUME ["/data"]

ENTRYPOINT ["/bin/sh","-c"]

CMD ["executable","param1","param2"]

CMD [ "echo", "$HOME" ]

CMD [ "sh", "-c", "echo $HOME" ]

ONBUILD RUN echo "你把我当作基础镜像了" \
              && echo "构建当前镜像我不执行"

STOPSIGNAL signal

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

WORKDIR /path/to/workdir
