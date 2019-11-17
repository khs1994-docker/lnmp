# 内核模块相关命令

显示当前被内核加载的模块

```bash
$ lsmod
$ cat /proc/modules
```

向内核增加或者删除指定模块

```bash
# 默认是增加模块
$ modprobe XXX
# 删除模块
$ modprobe -r XXX
```
