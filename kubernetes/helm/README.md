# Helm

* [配置文件](https://helm.sh/docs/chart_template_guide/#accessing-files-inside-templates)

## 部署

* [官方文档-模板配置](https://helm.sh/docs/chart_template_guide/#the-chart-template-developer-s-guide)

```bash
$ helm install ./ --name XXX --namespace NS --set
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
