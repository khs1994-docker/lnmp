## Ubuntu

```bash
$ UBUNTU_URL=mirrors.ustc.edu.cn
$ UBUNTU_SECURITY_URL=mirrors.ustc.edu.cn
$ sudo sed -i "s/archive.ubuntu.com/${UBUNTU_URL}/g" /etc/apt/sources.list
$ sudo sed -i "s/security.ubuntu.com/${UBUNTU_SECURITY_URL}/g" /etc/apt/sources.list
```

## Debian

```bash
$ DEB_URL=mirrors.ustc.edu.cn
$ sudo sed -i "s/deb.debian.org/${DEB_URL}/g" /etc/apt/sources.list
$ sudo sed -i "s/security.debian.org/${DEB_URL}/g" /etc/apt/sources.list
$ sudo sed -i "s/ftp.debian.org/${DEB_URL}/g" /etc/apt/sources.list
```
