# Dockerfile

[官方文档](https://github.com/docker-library/docs)

```bash
$ cd SOFT_NAME

$ cp .env.example .env

$ vi .env

$ cp example.Dockerfile Dockerfile

$ docker-compose build
```

## BuildKit

* https://hub.docker.com/r/tonistiigi/dockerfile/tags/

通过以下命令启用 `BuildKit`

```bash
$ export DOCKER_BUILDKIT=1
```

要使用以下参数必须在 `Dockerfile` 中加上 `# syntax = tonistiigi/dockerfile:20181026-ssh` 这样的指令，具体查看对应的示例 `Dockerfile`

### `--secret`

* https://github.com/docker/cli/pull/1288

构建时使用密钥文件

```bash
$ docker pull tonistiigi/dockerfile:20181026-secrets

$ docker build --secret id=mysecret,src=$(pwd)/mysecret.txt -f buildkit.Dockerfile .
```

### `--ssh`

* https://github.com/docker/cli/pull/1419

构建时使用宿主机的 ssh 密钥

```bash
$ eval $(ssh-agent)
$ ssh-add ~/.ssh/id_rsa
(Input your passphrase here)

$ docker pull tonistiigi/dockerfile:20181026-ssh

$ docker build --ssh default=$SSH_AUTH_SOCK -f buildkit.ssh.Dockerfile .
```
