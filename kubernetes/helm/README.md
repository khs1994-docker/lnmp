# Helm LNMP

* [部署 Helm](https://github.com/khs1994-docker/lnmp-k8s/blob/master/docs/helm.md)

* [配置文件](https://docs.helm.sh/chart_template_guide/#accessing-files-inside-templates)

配置文件位于 `SOFT_NAME/config/*` 目录中

## 部署 LNMP

### 注意事项

* [官方文档-模板配置](https://docs.helm.sh/chart_template_guide/#the-chart-template-developer-s-guide)

* 本项目已将 LNMP 架构分解成 NGINX & PHP + MySQL + Redis + N 多个 Helm 包

### 四种环境

编辑 `.env` 文件或 `.env.ps1` (Windows Only) 中的 `HELM_SERVICES` 变量,修改启用的 helm 包

```bash
HELM_SERVICES="redis mysql nginx-php"
```

部署

```bash
$ ./lnmp-k8s helm-development [--debug]

$ ./lnmp-k8s helm-testing [--debug]

$ ./lnmp-k8s helm-staging [--debug]

$ ./lnmp-k8s helm-production [--debug]
```

## 删除

```bash
$ helm list

$ helm delete NAME --purge
```

## 回退

```bash
$ helm rollback RELEASE_NAME N
```

## 官方仓库 Charts

* https://github.com/helm/charts

## More Information

* https://www.kubernetes.org.cn/3435.html
