# Nginx With HTTP3

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/nginx.svg?style=social&label=Stars)](https://github.com/khs1994-docker/nginx)  [![GitHub release](https://img.shields.io/github/release/khs1994-docker/nginx.svg)](https://github.com/khs1994-docker/nginx/releases) [![Docker Stars](https://img.shields.io/docker/stars/khs1994/nginx.svg)](https://hub.docker.com/r/khs1994/nginx/) [![Docker Pulls](https://img.shields.io/docker/pulls/khs1994/nginx.svg)](https://hub.docker.com/r/khs1994/nginx/)

* https://blog.khs1994.com/linux/ssl/https/README.html

* https://github.com/khs1994-docker/lnmp/issues/137
* https://github.com/khs1994-docker/lnmp/issues/895

| Verson     | Details     |
| :------------- | :------------- |
| [![](https://images.microbadger.com/badges/version/khs1994/nginx:1.19.5-alpine.svg)](https://microbadger.com/images/khs1994/nginx:1.19.5-alpine "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/khs1994/nginx:1.19.5-alpine.svg)](https://microbadger.com/images/khs1994/nginx:1.19.5-alpine "Get your own image badge on microbadger.com") |
| [![](https://images.microbadger.com/badges/version/khs1994/nginx:1.19.5-buster.svg)](https://microbadger.com/images/khs1994/nginx:1.19.5-buster "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/khs1994/nginx:1.19.5-buster.svg)](https://microbadger.com/images/khs1994/nginx:1.19.5-buster "Get your own image badge on microbadger.com") |

## 注意

* 只有一个 `server {}` 能启用 HTTP3，多个 `server {}` 启用 HTTP3 会提示冲突。

## 测试浏览器是否支持 HTTP3

* https://quic.tech:8443

**chrome 83+**

```bash
--enable-quic --quic-version=h3-27 --origin-to-force-quic-on=example.com:443
```

**firefox 75+**

`about:config` -> `network.http.http3.enabled = true`

## 草案

* https://datatracker.ietf.org/doc/draft-ietf-quic-transport/history/

## `Docker Compose`

```yaml
version: "3"

services:
  nginx:
    image: "khs1994/nginx:1.19.5-alpine"
    ports:
      - "80:80"
      - "443:443/tcp"
      - "443:443/udp"
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./conf.d:/etc/nginx/conf.d:ro
```

## `$ docker run`

```bash
$ docker run -dit \
         -e TZ=Asia/Shanghai \
         -p 80:80/tcp \
         -p 443:443/tcp \
         -p 443:443/udp \
         -v $PWD/app:/app \
         -v $PWD/conf.d:/etc/nginx/conf.d \
         khs1994/nginx:1.19.5-alpine
```

# Who use it?

[khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp) use this Docker Image.

# Compare

```bash
$ docker-compose up alpine | buster | official

$ h2load -n 100 -c 10 https://t.khs1994.com
```

## alpine

```bash
finished in 772.28ms, 129.49 req/s, 22.08KB/s
requests: 100 total, 100 started, 100 done, 100 succeeded, 0 failed, 0 errored, 0 timeout
status codes: 100 2xx, 0 3xx, 0 4xx, 0 5xx
traffic: 17.05KB (17463) total, 1.63KB (1673) headers (space savings 90.49%), 13.18KB (13500) data
                     min         max         mean         sd        +/- sd
time for request:     5.84ms     89.32ms     48.74ms     18.40ms    75.00%
time for connect:    53.88ms    399.50ms    201.96ms    122.59ms    70.00%
time to 1st byte:    92.99ms    460.74ms    233.89ms    120.97ms    70.00%
req/s           :      12.99       17.08       14.62        1.41    70.00%
```

## buster

```bash
finished in 954.81ms, 104.73 req/s, 17.93KB/s
requests: 100 total, 100 started, 100 done, 100 succeeded, 0 failed, 0 errored, 0 timeout
status codes: 100 2xx, 0 3xx, 0 4xx, 0 5xx
traffic: 17.12KB (17532) total, 1.70KB (1742) headers (space savings 90.10%), 13.18KB (13500) data
                     min         max         mean         sd        +/- sd
time for request:    10.71ms    103.80ms     71.21ms     17.92ms    74.00%
time for connect:   118.40ms    307.03ms    178.26ms     61.53ms    80.00%
time to 1st byte:   163.51ms    396.44ms    232.83ms     73.78ms    80.00%
req/s           :      10.59       12.09       11.35        0.57    60.00%
```

## official

```bash
finished in 701.79ms, 142.49 req/s, 36.88KB/s
requests: 100 total, 100 started, 100 done, 100 succeeded, 0 failed, 0 errored, 0 timeout
status codes: 100 2xx, 0 3xx, 0 4xx, 0 5xx
traffic: 25.88KB (26500) total, 10.56KB (10710) headers (space savings 39.15%), 13.18KB (13500) data
                     min         max         mean         sd        +/- sd
time for request:     9.32ms     62.95ms     49.54ms      9.66ms    83.00%
time for connect:    82.70ms    285.17ms    150.81ms     70.20ms    80.00%
time to 1st byte:   123.90ms    318.23ms    194.80ms     70.23ms    70.00%
req/s           :      14.26       16.78       15.52        0.96    50.00%
```

# More Infortion

* [khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp)
* [Official NGINX Dockerfiles](https://github.com/nginxinc/docker-nginx)
* https://github.com/hakasenyang/openssl-patch
* https://www.nginx.com/blog/introducing-technology-preview-nginx-support-for-quic-http-3/
* https://quic.nginx.org/README
* https://hg.nginx.org/nginx-quic
* https://asnokaze.hatenablog.com/entry/2020/06/11/133357
* https://www.grottedubarbu.fr/nginx-quic-http3/
* https://jiyiren.github.io/2020/06/17/quic-explain-build/
