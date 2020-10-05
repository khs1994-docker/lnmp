https://docs.microsoft.com/zh-cn/windows/wsl/wsl2-mount-disk

```bash
$ wmic diskdrive list brief

$ start-process "wsl" -ArgumentList "--mount", "$DeviceID", "--bare" -Verb runAs

$ wsl -d ubuntu -u root -- lsblk

$ wsl -d ubuntu -u root -- mount /dev/sdX3 /app
```
