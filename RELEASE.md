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

## 同步镜像到国内 [`ccr.ccs.tencentyun.com/library-mirror`](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

使用 `dockerfile/sync` 在 Coding.net CI 同步镜像到国内 [`ccr.ccs.tencentyun.com/library-mirror/SOFT(e.g. redis)`](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)
