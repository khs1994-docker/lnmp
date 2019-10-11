# Supervisord

* http://supervisord.org

在 `.env` 文件中将 `supervisord` 包含进来。Windows 用户请在 `.env.ps1` 中修改。

```bash
LNMP_SERVICES="nginx mysql php7 redis phpmyadmin supervisord"
```

配置文件位于 `config/supervisord/supervisord.ini`，编辑配置文件。

启动

```bash
$ lnmp-docker up
```

## 宿主机使用

```bash
$ sudo pip install supervisor
```

```bash
$ sudo mkdir -p /etc/supervisor.d

$ sudo cp config/supervisord/supervisord.ini /etc/supervisor.d/supervisord.ini

# 生成默认的配置文件
$ echo_supervisord_conf | sudo tee /etc/supervisord.conf

# 调整 /etc/supervisord.conf 配置
# 加入以下内容
[include]
files = /etc/supervisor.d/*.ini

# 启动服务端
$ sudo supervisord -u root -c /etc/supervisord.conf
```
