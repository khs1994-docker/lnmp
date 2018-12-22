# 端口

## nodePort

外部机器可访问的端口，节点的端口。

## targetPort

容器的端口（最根本的端口入口），与制作容器时暴露的端口一致（ DockerFile 中 **EXPOSE** )

## port

Kubernetes 中的 **服务之间** 访问的端口,尽管 MySQL 容器暴露了 3306 端口,但是集群内其他容器需要通过 33306 端口访问该服务，外部机器不能访问mysql服务，因为他没有配置NodePort类型
