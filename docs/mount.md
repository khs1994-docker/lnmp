# 文件挂载相关命令

**1.** 将 oldDir 挂载到 newDir

```bash
$ mount --bind oldDir newDir
```

**2.** 是否被挂载

```bash
$ mountpoint -q /mnt/c
```
