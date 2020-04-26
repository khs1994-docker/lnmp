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

## 同步镜像到国内 [`ccr.ccs.tencentyun.com/khs1994`](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

复制 `dockerfile/Jenkinsfile` 到 Coding.net CI 同步镜像到国内 [`ccr.ccs.tencentyun.com/khs1994/SOFT(redis)`](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)
