# SSL

```bash
Listen 443

SSLProtocol             all -SSLv3 -TLSv1 -TLSv1.1
SSLCipherSuite          ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256
SSLHonorCipherOrder     on
# Docker 镜像暂不支持该选项
# SSLCompression          off
SSLSessionTickets       off

SSLUseStapling                    on
SSLStaplingResponderTimeout       5
SSLStaplingReturnResponderErrors  off
SSLStaplingCache                  shmcb:/var/run/ocsp(128000)

SSLSessionCache        "shmcb:/usr/local/apache2/logs/ssl_scache(512000)"
SSLSessionCacheTimeout  300

Include conf.d/*.conf
```
