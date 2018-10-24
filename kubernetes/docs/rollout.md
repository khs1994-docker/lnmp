# 滚动更新

## Deployment

更新 `Image`

```bash
$ kubectl set image deployment DEPLOYMENT_NAME CONTAINER_NAME=nginx:v3 --record
```

执行 `$ kubectl edit ` 编辑 YAML 文件更新

```bash
$ kubectl edit deployment DEPLOYMENT_NAME
```

查看更新历史

```bash
$ kubectl rollout history deployment DEPLOYMENT_NAME
```

```bash
$ kubectl rollout pause | resume | status
```

```bash
$ kubectl rolling-update DEPLOYMENT_NAME --update-period=10s -f NEW_YAML_FILE
```

## 回滚 undo

回滚到指定版本

```bash
$ kubectl rollout undo deployment DEPLOYMENT_NAME --to-revision=7
```
