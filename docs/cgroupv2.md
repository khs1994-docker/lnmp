# cGroupv2

## Fedora 31

* https://www.linuxprobe.com/fedora-30-shell.html

```bash
$ sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"

# 恢复
# $ sudo grubby --update-kernel=ALL --remove-args="systemd.unified_cgroup_hierarchy=0"
```

* https://github.com/docker/for-linux/issues/665
