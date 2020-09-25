# [CIFS(SMB, Samba, Windows Share)](https://github.com/docker-practice/flexvolume_cifs)

**静态**

* https://hub.docker.com/r/dockerpracticesig/flexvolume-cifs

* https://github.com/kubernetes/examples/tree/master/staging/volumes/flexvolume

* https://github.com/fstab/cifs
* https://blog.csdn.net/changqing1234/article/details/81128548
* https://blog.csdn.net/jay_youth/article/details/80550775

## 安装依赖

> 插件由 kubelet 在节点调用，必须保证节点安装了挂载文件所需的依赖包。

```bash
$ sudo apt install -y cifs-utils jq util-linux coreutils
```

## 安装

> 不支持 Docker Desktop k8s

以 `Daemonset` 方式部署

> `KUBELET_PLUGINS_VOLUME_PATH` 为 `kubelet --volume-plugin-dir=/usr/libexec/kubernetes/kubelet-plugins/volume/exec/` 参数指定的值

`Linux/macOS` 请执行如下命令:

```bash
# $ KUBELET_PLUGINS_VOLUME_PATH=${K8S_ROOT:-/opt/k8s}/usr/libexec/kubernetes/kubelet-plugins/volume/exec
$ KUBELET_PLUGINS_VOLUME_PATH="/usr/libexec/kubernetes/kubelet-plugins/volume/exec"

$ sed "s%##KUBELET_PLUGINS_VOLUME_PATH##%${KUBELET_PLUGINS_VOLUME_PATH:?value empty}%g" deploy/deploy.yaml | kubectl apply -f -
```

`Windows` 请执行如下命令:

```powershell
$ PS:> $KUBELET_PLUGINS_VOLUME_PATH="/usr/libexec/kubernetes/kubelet-plugins/volume/exec"

$ PS:> (get-content deploy/deploy.yaml) -Replace "##KUBELET_PLUGINS_VOLUME_PATH##",${KUBELET_PLUGINS_VOLUME_PATH} | kubectl apply -f -
```

## 测试

## 部署服务端

> 如果你有自己的 SMB 服务，可以跳过此步骤，参考下一小节

```bash
$ kubectl apply -k ../../../deploy/smb-server
```

上边启动的 smb 服务端固定集群 IP 为 **10.254.0.45**

```bash
$ kubectl apply -f tests
$ kubectl apply -f tests/inline
```

### 自己的 smb 服务端

配置 `secret`

生成用户名及密码

```bash
$ echo -n username | base64
$ echo -n password | base64
```

将上面的结果在 `tests/secret.yaml` 中进行替换。

```bash
$ kubectl apply -f tests/secret.yaml
```

> `inline/pod.yaml` 中替换 `//HIWIFI/sd/xunlei` 为网络路径

```bash
$ kubectl apply -f tests/pod.yaml
```

进入 `pod` 的 `/data` 目录，新建文件。在 CIFS 服务端查看文件是否存在。

### 挂载 Windows 盘符(例如 C 盘文件)

Windows 盘符开启共享请查看 [这里](https://jingyan.baidu.com/article/e2284b2b6d8afbe2e6118d01.html)

假设 `192.168.199.100` 为 Windows IP，网络路径则为: `//192.168.199.100//c`

## 参考

### 排错

使用 `describe` 命令或者查看 `kubelet` 的日志。

### 宿主机挂载

```bash
# 用 用户/密码 登录
$ mount -t cifs //<host>/<path> /<localpath> -o user=<user>,password=<password>

# 用 游客 登录
$ mount -t cifs //<host>/<path> /<localpath> -o guest
```
