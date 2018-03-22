# Crontab 计划任务

## 编辑宿主机配置文件

```bash
* * * * * /usr/local/bin/docker exec -it $( docker container ls --format '{{.ID}}' -f label=com.khs1994.com -f label=com.docker.compose.service=php7 ) sh -c "php /app/path-to-your-project/artisan schedule:run >> /dev/null 2>&1"

* * * * * /usr/local/bin/docker exec -it $( docker container ls --format '{{.ID}}' -f label=com.khs1994.com -f label=com.docker.swarm.service.name=lnmp_php7 ) sh -c "php /app/path-to-your-project/artisan schedule:run >> /dev/null 2>&1"
```
