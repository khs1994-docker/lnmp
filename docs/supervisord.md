# Supervisord

* http://supervisord.org

在 `.env` 文件中将 `supervisord` 包含进来。Windows 用户请在 `.env.ps1` 中修改。

```bash
LNMP_INCLUDE="nginx mysql php7 redis phpmyadmin supervisord"
```

配置文件位于 `config/supervisord/supervisord.ini`，编辑配置文件。

启动

```bash
$ lnmp-docker up
```
