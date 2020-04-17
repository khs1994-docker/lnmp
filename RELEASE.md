# 版本发布流程

## 修改以下文件中的版本号

* CHANGELOG.md
* lnmp-docker.ps1

**主、次版本号**

* cli/.env
* cli/.env.ps1
* 全部搜索替换

## 发布 `lnmp-docker.ps1`

```powershell
$ Publish-Script -Path ${PWD}/lnmp-docker.ps1 -NuGetApiKey $env:NUGET_API_KEY -Force
```
