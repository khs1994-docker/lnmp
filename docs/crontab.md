# Crontab 计划任务

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## 编辑宿主机 crontab 配置文件

```bash
$ crontab -e
```

```bash
* * * * * /usr/local/bin/docker exec -it $( docker container ls --format '{{.ID}}' -f label=com.khs1994.com -f label=com.docker.compose.service=php7 ) sh -c "php /app/path-to-your-project/artisan schedule:run >> /dev/null 2>&1"

* * * * * /usr/local/bin/docker exec -it $( docker container ls --format '{{.ID}}' -f label=com.khs1994.com -f label=com.docker.swarm.service.name=lnmp_php7 ) sh -c "php /app/path-to-your-project/artisan schedule:run >> /dev/null 2>&1"
```

原理：通过在 **宿主机** 计划执行 `docker exec ***`，变相实现容器内计划任务，只适用于 **单机环境**。
