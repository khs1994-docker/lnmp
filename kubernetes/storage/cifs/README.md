# CIFS(SMB, Samba, Windows Share)

* https://github.com/fstab/cifs
* https://blog.csdn.net/changqing1234/article/details/81128548
* https://blog.csdn.net/jay_youth/article/details/80550775

安装依赖

```bash
$ sudo apt install -y cifs-utils jq util-linux coreutils
```

```bash
$ VOLUME_PLUGIN_DIR="${K8S_ROOT:-/opt/k8s}/var/lib/kubelet/kubelet-plugins/volume/exec/"
$ sudo mkdir -p "$VOLUME_PLUGIN_DIR/fstab~cifs"
$ cd "$VOLUME_PLUGIN_DIR/fstab~cifs"
$ sudo curl -L -O https://raw.githubusercontent.com/fstab/cifs/master/cifs
$ sudo chmod 755 cifs

$ $VOLUME_PLUGIN_DIR/fstab~cifs/cifs init
```

```bash
# 替换 //HIWIFI/sd/xunlei 为网络路径

$ kubectl apply -f storage/cifs/deploy.yaml
```

## 挂载 Windows 盘符(例如 C 盘文件)

网络路径为: `//192.168.199.100//c`

> 192.168.199.100 为 Windows IP

* https://jingyan.baidu.com/article/e2284b2b6d8afbe2e6118d01.html

## 宿主机挂载

```bash
# 用用户/密码登录
$ mount -t cifs //<host>/<path> /<localpath> -o user=<user>,password=<user>

# 用游客登录
$ mount -t cifs //<host>/<path> /<localpath> -o guest
```
