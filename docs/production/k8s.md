# Docker for Mac 支持 k8s

启用 k8s 之后，输入如下命令

```bash
$ docker stack deploy -c docker-stack.yml lnmp

$ docker stack services lnmp

$ kubectl get services

$ kubectl get pod
```
