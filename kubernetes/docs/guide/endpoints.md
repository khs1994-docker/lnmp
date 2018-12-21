# 服务 Endpoints

**将外部服务映射到内部**

* https://blog.csdn.net/liyingke112/article/details/76204038

## nodePort

外部机器可访问的端口。

## targetPort

容器的端口（最根本的端口入口），与制作容器时暴露的端口一致（ DockerFile 中 **EXPOSE** )

## port

Kubernetes 中的 **服务之间** 访问的端口,尽管 MySQL 容器暴露了 3306 端口,但是集群内其他容器需要通过 33306 端口访问该服务，外部机器不能访问mysql服务，因为他没有配置NodePort类型

```yaml
apiVersion: v1
kind: Service
metadata:
  name: lykops
spec:
  ports:
  - port: 80
    targetPort: 81
    protocol: TCP
---
apiVersion: v1
kind: Endpoints
metadata:
  name: lykops
subsets:
  - addresses:
    - ip: 172.17.241.47
    - ip: 59.107.26.221
    ports:
    - port: 80
      protocol: TCP
```
