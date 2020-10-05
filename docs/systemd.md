# systemd

systemd 文件位于 `cli/systemd/*`

适用于 `Linux x86_64` 开发环境。

>务必熟悉 `systemd` 之后再执行此项操作。

```bash
$ sudo cp $LNMP_PATH/cli/systemd/lnmp-docker.service /etc/systemd/system/

$ sudo vi /etc/systemd/system/lnmp-docker.service

# 务必自行修改路径为本项目实际路径

$ sudo systemctl daemon-reload

$ sudo systemctl start lnmp-docker

$ sudo systemctl status lnmp-docker

$ sudo systemctl stop lnmp-docker

$ sudo journalctl -u lnmp-docker
```

## 每周清理日志

```bash
$ sudo cp -a $LNMP_PATH/cli/systemd/*-cleanup /etc/systemd/system/

$ sudo vi /etc/systemd/system/lnmp-docker-cleanup.service

# 务必自行修改路径为本项目实际路径

$ sudo systemctl daemon-reload

$ sudo systemctl enable cleanup-lnmp-docker.timer

$ sudo systemctl start cleanup-lnmp-docker.timer

$ systemctl list-timers

$ sudo journalctl -u cleanup-lnmp-docker
```

## 定时备份数据文件

与上方内容类似，这里不再赘述。

## Laravel 队列(Queue)

原理就是执行 `$ docker exec -it PHP_CONTAINER_ID COMMAND`

由 `systemd` 管理

## Laravel 调度器(Schedule)

原理就是执行 `$ docker exec -it PHP_CONTAINER_ID COMMAND`

由 `systemd` 管理

# More Information
