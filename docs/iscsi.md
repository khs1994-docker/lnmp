# ISCSI

## target（服务端）

```bash
$ yum -y install targetcli
```

使用 `targetcli` 创建 `/etc/target/saveconfig.json` 文件

```bash
ExecStart=/usr/bin/targetctl restore
```

启动，监听 `3260` 端口

## 启动器（客户端）

```bash
$ yum -y install iscsi-initiator-utils
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

## 参考

* https://blog.csdn.net/wh211212/article/details/52981305
* https://blog.csdn.net/cmzsteven/article/details/80417025
* https://blog.csdn.net/ha_weii/article/details/80586753
