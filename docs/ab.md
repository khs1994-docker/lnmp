# ab command

* https://github.com/khs1994-docker/lnmp/issues/397

```bash
$ ab -c100 -n100 https://test2.t.khs1994.com/index.php
```

# HTTP2 测试工具

* https://github.com/nghttp2/nghttp2/releases

```bash
$ sudo apt install nghttp2

$ h2load -n 100 -c 10 url
```
