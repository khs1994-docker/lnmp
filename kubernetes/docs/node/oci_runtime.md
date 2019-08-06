# OCI Runtime

* https://kubernetes.io/docs/concepts/containers/runtime-class/

## runc

* https://github.com/opencontainers/runc

## gvisor(runsc)

* https://github.com/google/gvisor
* https://gvisor.dev/docs/user_guide/docker/

### Kubernetes(Containerd)

* https://github.com/google/gvisor-containerd-shim
* https://github.com/google/gvisor-containerd-shim/blob/master/docs/runtime-handler-shim-v2-quickstart.md

```bash
$ sudo curl -fsSL -o /usr/local/bin/containerd-shim-runsc-v1 https://github.com/google/gvisor-containerd-shim/releases/download/v0.0.3/containerd-shim-runsc-v1.linux-amd64

$ sudo chmod +x /usr/local/bin/containerd-shim-runsc-v1
```

`/etc/containerd/config.toml`

```toml
[plugins.cri.containerd.runtimes.runsc]
  runtime_type = "io.containerd.runsc.v1"
```

```bash
$ sudo systemctl restart containerd
```

```yaml
apiVersion: node.k8s.io/v1beta1  # RuntimeClass is defined in the node.k8s.io API group
kind: RuntimeClass
metadata:
  name: myclass  # The name the RuntimeClass will be referenced by
  # RuntimeClass is a non-namespaced resource
# handler: myconfiguration  # The name of the corresponding CRI configuration
handler: runsc # 值与 OCI 配置文件对应
```

`containerd`

```toml
# [plugins.cri.containerd.runtimes.${HANDLER_NAME}]
[plugins.cri.containerd.runtimes.runsc]
...
```

`oci-o`

```toml
# [crio.runtime.runtimes.${HANDLER_NAME}]
[crio.runtime.runtimes.runsc]
#  runtime_path = "${PATH_TO_BINARY}"
  runtime_path = "/usr/local/bin/runsc"
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  runtimeClassName: myclass
  # ...
```

### Docker

```bash
$ sudo curl -fsSL -o /usr/local/bin/runsc https://github.com/khs1994-docker/gvisor-mirror/releases/download/nightly/runsc

$ sudo chmod +x /usr/local/bin/runsc
```

`/etc/docker/daemon.json`

```json
{
    "runtimes": {
        "runsc": {
            "path": "/usr/local/bin/runsc"
        }
    }
}
```

```bash
$ docker run --runtime=runsc --rm hello-world
```
