# 滚动更新

参数

```bash
history     显示 rollout 历史
pause       标记提供的 resource 为中止状态
resume      继续一个停止的 resource
status      显示 rollout 的状态
undo        撤销上一次的 rollout
```

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

## 回滚 undo

回滚到指定版本

```bash
$ kubectl rollout undo deployment DEPLOYMENT_NAME --to-revision=7
```
