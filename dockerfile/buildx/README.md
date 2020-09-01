## BuildKit

* https://hub.docker.com/r/docker/dockerfile/tags/
* https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md
* https://docs.docker.com/engine/reference/commandline/build/

通过以下命令启用 `BuildKit`

```bash
$ export DOCKER_BUILDKIT=1

# Windows powershell
$env:DOCKER_BUILDKIT=1
```

要使用以下参数必须在 `Dockerfile` 中加上 `# syntax=docker/dockerfile:experimental` 这样的指令，具体查看对应的示例 `Dockerfile`

### `--secret`

* https://github.com/docker/cli/pull/1288

构建时使用密钥文件

```bash
$ docker buildx build --secret id=mysecret,src=$(pwd)/mysecret.txt --progress=plain -f Dockerfile .
```

### `--ssh`

* https://github.com/docker/cli/pull/1419

构建时使用宿主机的 ssh 密钥

```bash
$ eval $(ssh-agent)
$ ssh-add ~/.ssh/id_rsa
(Input your passphrase here)

$ docker buildx build --ssh default=$SSH_AUTH_SOCK --progress=plain -f buildkit.ssh.Dockerfile .
```

### --cache-from=[NAME|type=TYPE[,KEY=VALUE]]

```bash
$ docker buildx build --cache-from=user/app .
$ docker buildx build --cache-from=type=registry,ref=user/app .
$ docker buildx build --cache-from=type=local,src=path/to/cache .
```

```bash
$ docker buildx build --cache-from=php:7.4-fpm-cache .
```

### --cache-to=[NAME|type=TYPE[,KEY=VALUE]]

```bash
$ docker buildx build --cache-to=user/app:cache .
$ docker buildx build --cache-to=type=inline .
$ docker buildx build --cache-to=type=registry,ref=user/app .
$ docker buildx build --cache-to=type=local,dest=path/to/cache .
```
