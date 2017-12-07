# LinuxKit Run LNMP

编写 PHP 项目源代码

```bash
# 在 dockerfile/* 编写 Dockerfile.linuxkit

# 在当前目录执行

$ docker-compose build

$ docker-compose push

$ linuxkit build lnmp.yml

$ linuxkit run -publish 8080:80/tcp lnmp
```

* https://github.com/linuxkit/linuxkit
