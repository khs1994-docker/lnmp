# ISCSI

> 这里只记录关键部分，实际操作请查看参考一节中的文章

## target（服务端）

```bash
$ yum install -y targetcli

$ apt install -y targetcli-fb
```

使用 `targetcli` 创建 `/etc/target/saveconfig.json` 文件

```bash
ExecStart=/usr/bin/targetctl restore
```

启动，监听 `3260` 端口

## initiator（客户端）

```bash
$ yum -y install iscsi-initiator-utils

$ apt -y install open-iscsi
```

```bash
# iscsid.service

ExecStart=/usr/sbin/iscsid
```

```bash
# iscsi.service

ExecStart=-/sbin/iscsiadm -m node --loginall=automatic
```

```bash
# /etc/iscsi/initiatorname.iscsi

InitiatorName=iqn.2018-05.com.test:desktop
```

## WSL2

* 使用笔者编译的 [内核](https://github.com/khs1994/WSL2-Linux-Kernel)

```bash
$ sudo service dbus start
```

## 参考

* https://blog.csdn.net/wh211212/article/details/52981305
* https://blog.csdn.net/cmzsteven/article/details/80417025
* https://blog.csdn.net/ha_weii/article/details/80586753

* https://kifarunix.com/how-to-install-and-configure-iscsi-storage-server-on-ubuntu-18-04/
