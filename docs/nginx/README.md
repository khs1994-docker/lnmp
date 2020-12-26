# NGINX

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

```bash
$ nginx -s stop # 立即关闭

$ nginx -s quit # 正常关闭

$ nginx -s reload # 重新加载配置文件

$ nginx -s reopen # 重新打开日志文件
```

```nginx
http {
  keepalive_timeout  100;

  fastcgi_connect_timeout 6000;
  fastcgi_send_timeout 6000;
  fastcgi_read_timeout 6000;

  client_header_timeout 120s
  client_body_timeout 120s;
  client_max_body_size 100m;         #主要是这个参数，限制了上传文件大大小

  server {

  }
}

upstream myapp1 {
    # 随机 1.15.1 +
    random;
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
  # https://juejin.cn/post/6844903641317376013
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

    # 防盗链
    valid_referers none blocked *.hugao8.com www.hugao8.com m.hugao8.com *.baidu.com *.google.com;
    if ($invalid_referer) {
    rewrite ^/ http://ww4.sinaimg.cn/bmiddle/051bbed1gw1egjc4xl7srj20cm08aaa6.jpg;
    # none : 允许没有 http_refer 的请求访问资源
    # blocked : 允许不是 http:// 开头的，不带协议的请求访问资源

    # auth
    auth_basic           "closed site";
    auth_basic_user_file conf/htpasswd;

    # 访问控制

    deny  192.168.1.1;
    allow 192.168.1.0/24;
    allow 10.1.1.0/16;
    allow 2001:0db8::/32;
    deny  all;
  }

  # nginx 将选择具有最长前缀的 location 块
  # /images/top.gif 的请求，将发送服务器路径为 /data/images/top.gif 的文件
  # 注意与 alias 区别，alias 会丢弃 location 的前缀
  location /images/ {
    root /data;
  }

  # 代理配置
  location /test/ {
    proxy_pass http://localhost:8080;
    proxy_connect_timeout   300;         #这三个超时时间适量调大点
    proxy_send_timeout      600;
    proxy_read_timeout      600;
    proxy_set_header X-Real-IP $remote_addr;    # 获取客户端真实IP
  }

  # /i/top.gif 的请求，将发送服务器路径为 /data/w3/images/top.gif 的文件
  location /i/ {
    alias /data/w3/images/;
  }

  error_page 404 /404.html;

  location /404.html {
    # 指定给定的 location 只能用于内部请求。对于外部请求，返回客户端错误 404（未找到）。
    internal;
  }

  # 以指定顺序检查文件是否存在，并使用第一个找到的文件进行请求处理。
  location / {
    try_files $uri $uri/ /index.php?$query_string;
  }
}
```
