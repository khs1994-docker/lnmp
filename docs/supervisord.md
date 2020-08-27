# Supervisord

* http://supervisord.org

在 `.env` 文件中将 `supervisord` 包含进来。

```bash
LNMP_SERVICES="nginx mysql php7 redis supervisord"
```

配置文件位于 `config/supervisord/supervisord.ini`。

启动

```bash
$ lnmp-docker up
```

## 宿主机使用

`supervisor` 为 C(supervisorctl)/S(supervisord) 架构

```bash
# $ sudo apt install python3 python3-pip
$ sudo pip3 install supervisor
```

```bash
$ sudo mkdir -p /etc/supervisor.d

# 子配置文件 /etc/supervisor.d/*.ini

# 生成默认的配置文件
$ echo_supervisord_conf | sudo tee /etc/supervisord.conf

# 调整 /etc/supervisord.conf 配置
# 加入以下内容
[include]
files = /etc/supervisor.d/*.ini

# 启动服务端
$ sudo supervisord -u root -c /etc/supervisord.conf
```

关闭服务端

```bash
$ sudo supervisorctl shutdown
```

## 参考

* https://blog.csdn.net/zyz511919766/article/details/43967793
