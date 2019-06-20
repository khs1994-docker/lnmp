FROM debian:stretch-slim

ARG NGINX_VERSION=1.17.0

ARG DEB_URL=deb.debian.org

ARG DEB_SECURITY_URL=security.debian.org/debian-security

ARG OPENSSL_URL=https://github.com/openssl/openssl

ARG OPENSSL_BRANCH=OpenSSL_1_1_1a

RUN set -x ; sed -i "s!deb.debian.org!${DEB_URL}!g" /etc/apt/sources.list \
&& sed -i "s!security.debian.org/debian-security!${DEB_SECURITY_URL}!g" /etc/apt/sources.list \
&& apt update \
  && apt install --no-install-recommends --no-install-suggests -y \
           patch \
           curl \
           git \
           ca-certificates \
           gcc \
           make \
           libpcre3 \
           libpcre3-dev \
           zlib1g \
           zlib1g-dev \
           libxslt1.1 \
           libxslt1-dev \
           libgd3 \
           libgd-dev \
           libgeoip1 \
           libgeoip-dev \
           libperl5.24 \
           libperl-dev \
           # gawk \
    && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
    && git clone -b $OPENSSL_BRANCH --depth=1 $OPENSSL_URL /srv/openssl \
    && cd /srv/openssl \
    && curl -fsSLO https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/openssl-equal-1.1.1a_ciphers.patch \
    && patch -p1 < openssl-equal-1.1.1a_ciphers.patch \
    && cd / \
  && GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 \
	&& CONFIG="\
    --with-openssl=/srv/openssl \
    --with-openssl-opt='enable-tls1_3' \
		--prefix=/etc/nginx \
		--sbin-path=/usr/sbin/nginx \
		--modules-path=/usr/lib/nginx/modules \
		--conf-path=/etc/nginx/nginx.conf \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
		--user=nginx \
		--group=nginx \
		--with-http_ssl_module \
		--with-http_realip_module \
		--with-http_addition_module \
		--with-http_sub_module \
		--with-http_dav_module \
		--with-http_flv_module \
		--with-http_mp4_module \
		--with-http_gunzip_module \
		--with-http_gzip_static_module \
		--with-http_random_index_module \
		--with-http_secure_link_module \
		--with-http_stub_status_module \
		--with-http_auth_request_module \
		--with-http_xslt_module=dynamic \
		--with-http_image_filter_module=dynamic \
		--with-http_geoip_module=dynamic \
		--with-threads \
		--with-stream \
		--with-stream_ssl_module \
		--with-stream_ssl_preread_module \
		--with-stream_realip_module \
		--with-stream_geoip_module=dynamic \
		--with-http_slice_module \
		--with-mail \
		--with-mail_ssl_module \
		--with-compat \
		--with-file-aio \
		--with-http_v2_module \
    --with-http_v2_hpack_enc \
	" \
	&& mkdir -p /usr/src \
	&& tar -zxC /usr/src -f nginx.tar.gz \
  && cd /usr/src/nginx-$NGINX_VERSION \
  && curl -fsSLO https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/nginx_hpack_push_1.15.3.patch \
  && patch -p1 < nginx_hpack_push_1.15.3.patch \
	&& ./configure $CONFIG --with-debug \
	&& make \
	&& mv objs/nginx objs/nginx-debug \
	&& mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
	&& mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
	&& mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
	&& mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so \
	&& ./configure $CONFIG \
	&& make \
	&& make install \
	&& mkdir /etc/nginx/conf.d/ \
  && rm -rf /etc/nginx/html/index.html \
	# && mkdir -p /usr/share/nginx/html/ \
	# && install -m644 html/index.html /usr/share/nginx/html/ \
	# && install -m644 html/50x.html /usr/share/nginx/html/ \
	&& install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
	&& install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so \
	&& install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so \
	&& install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so \
	&& install -m755 objs/ngx_stream_geoip_module-debug.so /usr/lib/nginx/modules/ngx_stream_geoip_module-debug.so \
	&& ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
	&& strip /usr/sbin/nginx* \
	&& strip /usr/lib/nginx/modules/*.so

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

FROM debian:stretch-slim

LABEL maintainer="khs1994.com nginx With TLSv1.3"

COPY --from=0 /etc/nginx /etc/nginx
COPY --from=0 /usr/lib/nginx /usr/lib/nginx
COPY --from=0 /usr/sbin/nginx* /usr/sbin/
COPY index.html /etc/nginx/html/

RUN groupadd -r nginx \
  && useradd -r -g nginx -s /bin/false -M nginx \
  && mkdir -p /var/log/nginx \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
  && mkdir -p /var/cache/nginx

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
