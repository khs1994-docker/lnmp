# pause 容器

* https://github.com/kubernetes/kubernetes/tree/master/build/pause
* https://github.com/rootsongjc/kubernetes-handbook/blob/master/concepts/pause-container.md

```bash
$ docker run -it --rm --name pause -p 8081:80 --ipc shareable registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2

$ docker run -it --rm \
    --network container:pause \
    --pid container:pause \
    --ipc=container:pause \
    nginx:1.19.0-alpine
# 能访问到 80 端口
```
