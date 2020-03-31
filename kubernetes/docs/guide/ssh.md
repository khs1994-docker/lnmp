# SSH 隧道

访问 windows ip => wsl2 ip

```bash
$ ssh -LNg 26443:wsl2:6443 khs1994@wsl2
```

```bash
# 本地转发 监听的端口在执行命令的主机
$ ssh -g -f -N -L forwardingPort:targetIP:targetPort user@sshServerIP

# targetIP 和 sshServerIP 可以相同，也可以不同
# 不同的话，sshServerIP 作为跳板代理 targetIP

# 远程转发 逆向转发 监听的端口在 sshServer
#
# 故只能通过 sshServer 的 127.0.0.1:forwardingPort
# 访问 targetIP:targetPort
$ ssh -f -N -R forwardingPort:targetIP:targetPort user@sshServerIP
```

* `-N` 不登录到服务端
* `-f` 后台运行
* `-g` 监听所有 IP

## 动态转发

```bash
$ ssh -D <local port> <SSH Server>
```

在浏览器设置 **socks** 代理服务器 `127.0.0.1:<local port>`，即可进行代理访问。

## 参考

* https://www.jianshu.com/p/20600c91e656
