# Crontab 计划任务

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

* https://crontab.guru/

## 选择1：宿主机运行 crontab

```bash
$ crontab -e
```

```bash
* * * * * /usr/local/bin/docker exec -i $( docker container ls --format '{{.ID}}' -f label=com.khs1994.com -f label=com.docker.compose.service=php7 ) sh -c "php /app/path-to-your-project/artisan schedule:run >> /dev/null 2>&1"

* * * * * /usr/local/bin/docker exec -i $( docker container ls --format '{{.ID}}' -f label=com.khs1994.com -f label=com.docker.swarm.service.name=lnmp_php7 ) sh -c "php /app/path-to-your-project/artisan schedule:run >> /dev/null 2>&1"
```

通过在 **宿主机** 计划执行 `docker exec ***`，变相实现容器内计划任务，只适用于 **单机环境**。

## 选择2：容器内运行 crontab

使用 `s6` 或 [supervisord](supervisord.md)

## Alpine 非 root 用户无法运行 crontab

* https://github.com/gliderlabs/docker-alpine/issues/381
* https://github.com/inter169/systs/blob/master/alpine/crond/README.md
