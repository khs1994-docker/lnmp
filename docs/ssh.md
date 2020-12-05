# SSH

## 错误

```bash
$ sudo service ssh start

* Starting OpenBSD Secure Shell server sshd

Could not load host key: /etc/ssh/ssh_host_rsa_key
Could not load host key: /etc/ssh/ssh_host_ecdsa_key
Could not load host key: /etc/ssh/ssh_host_ed25519_key
```

```bash
$ sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
$ sudo ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
$ sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
```

## 公钥放置到服务端 `~/.ssh/authorized_keys`

## 通过密码登录

```bash
# /etc/ssh/sshd_config.d/20-enable-passwords.conf
PasswordAuthentication yes
```
