# OCI Runtime

* https://kubernetes.io/docs/concepts/containers/runtime-class/
* https://github.com/opencontainers/runtime-spec/blob/master/implementations.md

* [runc](https://github.com/opencontainers/runc)
* [crun](https://github.com/containers/crun)
* [runsc](https://github.com/google/gvisor)
* [kata-containers](https://github.com/kata-containers/kata-containers)

## runc

* https://github.com/opencontainers/runc

## gvisor(runsc)

* https://github.com/google/gvisor
* https://gvisor.dev/docs/user_guide/docker/

### 在 Kubernetes 使用

#### Containerd

* https://github.com/google/gvisor-containerd-shim
* https://github.com/google/gvisor-containerd-shim/blob/master/docs/runtime-handler-shim-v2-quickstart.md

下载 `containerd-shim-runsc-v1`

```bash
$ sudo curl -fsSL -o /usr/local/bin/containerd-shim-runsc-v1 https://storage.googleapis.com/gvisor/releases/master/latest/containerd-shim-runsc-v1

$ sudo chmod +x /usr/local/bin/containerd-shim-runsc-v1
```

`/etc/containerd/config.toml`

```toml
# [plugins.cri.containerd.runtimes.${HANDLER_NAME}]
[plugins.cri.containerd.runtimes.runsc]
  runtime_type = "io.containerd.runsc.v1"
```

```bash
$ sudo systemctl restart containerd
```

#### cri-o

`/etc/crio/crio.conf`

```toml
# [crio.runtime.runtimes.${HANDLER_NAME}]
[crio.runtime.runtimes.runsc]
#  runtime_path = "${PATH_TO_BINARY}"
  runtime_path = "/usr/local/bin/runsc"
```

#### 使用

新建 `runtimeclass`

```yaml
apiVersion: node.k8s.io/v1beta1  # RuntimeClass is defined in the node.k8s.io API group
kind: RuntimeClass
metadata:
  name: myclass  # The name the RuntimeClass will be referenced by
  # RuntimeClass is a non-namespaced resource
# handler: myconfiguration  # The name of the corresponding CRI configuration
handler: runsc # 值与 CRI 配置文件对应 ${HANDLER_NAME}
```

使用 `runtimeclass`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  # 与 runtimeclass 配置文件的 metadata.name 对应
  runtimeClassName: myclass
  # ...
```

### 在 Docker 中使用

* `runsc` 与 `Docker` 的 `--exec-opt native.cgroupdriver=systemd` 不兼容。
* https://github.com/google/gvisor/issues/193

下载 `runsc`

```bash
$ curl -fsSL https://github.com/docker-practice/gvisor-mirror/releases/download/nightly/runsc-linux-amd64.tar.gz | sudo tar -C /usr/local/bin -zxvf -

$ ls /usr/local/bin/runsc

$ sudo chmod +x /usr/local/bin/runsc
```

配置 Docker

`/etc/docker/daemon.json`

```json
{
    "runtimes": {
        "runsc": {
            "path": "/usr/local/bin/runsc"
        },
        "runsc-kvm": {
            "path": "/usr/local/bin/runsc",
            "runtimeArgs": [
                "--platform=kvm"
          ]
        }
    }
}
```

在 Docker 中使用

```bash
$ docker run --runtime=runsc --rm hello-world
```

## 参考

安装 kvm

```bash
$ sudo apt-get install qemu-kvm
```
