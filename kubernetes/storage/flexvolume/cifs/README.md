# [CIFS(SMB, Samba, Windows Share)](https://github.com/docker-practice/flexvolume_cifs)

* https://hub.docker.com/r/dockerpracticesig/flexvolume-cifs

* https://github.com/fstab/cifs
* https://blog.csdn.net/changqing1234/article/details/81128548
* https://blog.csdn.net/jay_youth/article/details/80550775

## 安装依赖

```bash
$ sudo apt install -y cifs-utils jq util-linux coreutils
```

## 安装

> 不支持 Docker Desktop k8s

以 `Daemonset` 方式部署

> `KUBELET_PLUGINS_VOLUME_PATH` 为 `kubelet` `--volume-plugin-dir=` 参数指定的值

`Linux/macOS` 请执行如下命令:

```bash
# $ KUBELET_PLUGINS_VOLUME_PATH=${K8S_ROOT:-/opt/k8s}/var/lib/kubelet/kubelet-plugins/volume/exec/
$ KUBELET_PLUGINS_VOLUME_PATH="/usr/libexec/kubernetes/kubelet-plugins/volume/exec"

$ sed "s%##KUBELET_PLUGINS_VOLUME_PATH##%${KUBELET_PLUGINS_VOLUME_PATH:?value empty}%g" deploy/deploy.yaml | kubectl apply -f -
```

`Windows` 请执行如下命令:

```powershell
$ PS:> $KUBELET_PLUGINS_VOLUME_PATH="/usr/libexec/kubernetes/kubelet-plugins/volume/exec"

$ PS:> (get-content deploy/deploy.yaml) -Replace "##KUBELET_PLUGINS_VOLUME_PATH##",${KUBELET_PLUGINS_VOLUME_PATH} | kubectl apply -f -
```

## 测试

配置 `flexvolume-cifs-secret.yaml`

生成用户名及密码

```bash
$ echo -n username | base64
$ echo -n password | base64
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: flexvolume-cifs-secret
  namespace: default
type: fstab/cifs
data:
  username: 'ZXhhbXBsZQ==' # 自行替换
  password: 'bXktc2VjcmV0LXBhc3N3b3Jk' # 自行替换
```

```bash
$ kubectl apply -f flexvolume-cifs-secret.yaml
```

> `pod.yaml` 中替换 `//HIWIFI/sd/xunlei` 为网络路径

```bash
$ kubectl apply -f tests/pod.yaml
```

进入 `pod/flexvolume-tests-busybox` 的 `/data` 目录,新建文件.之后在 CIFS 服务端查看文件是否存在.具体步骤不再赘述

## 挂载 Windows 盘符(例如 C 盘文件)

Windows 盘符开启共享请查看 [这里](https://jingyan.baidu.com/article/e2284b2b6d8afbe2e6118d01.html)

网络路径则为: `//192.168.199.100//c`

> 192.168.199.100 为 Windows IP

## 宿主机挂载

```bash
# 用 用户/密码 登录
$ mount -t cifs //<host>/<path> /<localpath> -o user=<user>,password=<user>

# 用 游客 登录
$ mount -t cifs //<host>/<path> /<localpath> -o guest
```
