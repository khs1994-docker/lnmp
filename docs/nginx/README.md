# NGINX

```bash
$ nginx -s stop # 立即关闭

$ nginx -s quit # 正常关闭

$ nginx -s reload # 重新加载配置文件

$ nginx -s reopen # 重新打开日志文件
```

```nginx
http {
  server {

  }
}

upstream myapp1 {
    # 最少连接负载均衡
    least_conn;
    # 会话持久性
    ip_hash;
    # 加权负载均衡
    server srv1.example.com weight=3;
    server srv2.example.com;
    server srv3.example.com;
}

server {

  # https://docs.khs1994.com/nginx-docs.zh-cn/%E6%A8%A1%E5%9D%97%E5%8F%82%E8%80%83/http/ngx_http_gzip_module.html
  # https://juejin.im/post/5b518d1a6fb9a04fe548e8fc
  gzip              on;
  gzip_min_length   1k; # 不要压缩小于1000字节的文件
  gzip_proxied      expired no-cache no-store private auth;
  gzip_types        text/plain text/css application/json application/x-javascript text/xml application/xml text/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon; # 表示压缩的文件类型
  gzip_buffers      16 64k; # 设置用于压缩响应的缓冲区的数量（number）和大小（size）
  gzip_disable      "msie6";
  gzip_vary on;
  gzip_comp_level   6; # 设置响应的 gzip 压缩级别（level）。值的范围为 1 到 9。
  gzip_http_version 1.1; # 设置压缩响应一个请求所需的最小 HTTP 版本。

  location / {
    root /data/www;
    autoindex on; # 展示目录列表
    autoindex_exact_size on;
    autoindex_format html;
    autoindex_localtime off;
  }

  # nginx 将选择具有最长前缀的 location 块

  location /images/ {
    root /data;
  }

  # 代理配置
  location /test/ {
    proxy_pass http://localhost:8080;
  }

  # /i/top.gif 的请求，将发送 /data/w3/images/top.gif 文件
  location /i/ {
    alias /data/w3/images/;
  }

  # 指定给定的 location 只能用于内部请求。对于外部请求，返回客户端错误 404（未找到）。
  error_page 404 /404.html;

  location /404.html {
    internal;
  }

  # 以指定顺序检查文件是否存在，并使用第一个找到的文件进行请求处理。
  location / {
    try_files $uri $uri/ /index.php?$query_string;
  }

  # 访问控制
  location / {
    deny  192.168.1.1;
    allow 192.168.1.0/24;
    allow 10.1.1.0/16;
    allow 2001:0db8::/32;
    deny  all;
  }

  # auth

  location / {
    auth_basic           "closed site";
    auth_basic_user_file conf/htpasswd;
  }

}

```
