#!/usr/bin/env python3

import os
import sys

import wsl

input_sudo = ''
input_version = ''

if len(sys.argv) == 3:
    input_version = sys.argv[1]
    input_sudo = sys.argv[2]
else:
    wsl.print_help_info('lnmp-wsl-nginx-builder.py', 'NGINX', '1.13.11')
    exit(0)

sudo_cmd = 'echo ' + input_sudo + ' | sudo -S '

ret = os.system(sudo_cmd + 'ls > /dev/null 2>&1')

if ret != 0:
    print('\nsudo password is not correct\n')
    exit(1)

'''

'''

nginx_prefix = '/usr/local/nginx'
nginx_conf_dir = '/usr/local/etc/nginx'


def nginx_conf():
    cmd = sudo_cmd + '''nginx -T | grep "fastcgi_buffering off;" \
|| curl -fsSL https://raw.githubusercontent.com/khs1994-docker/lnmp/master/wsl/nginx.wsl.conf \
> /tmp/nginx.conf
'''

    os.system(cmd)
    cmd = 'sudo cp /tmp/nginx.conf ${nginx_conf_dir}/nginx.conf'.format(nginx_conf_dir=nginx_conf_dir)
    os.system(cmd)


def nginx_conf_d():
    nginx_conf_d_dir = '{nginx_conf_dir}/conf.d'.format(nginx_conf_dir=nginx_conf_dir)

    if os.path.exists(nginx_conf_d_dir):
        pass
    else:
        cmd = 'mkdir -p {nginx_conf_d_dir}'.format(nginx_conf_d_dir=nginx_conf_d_dir)
        os.system(sudo_cmd + cmd)


'''

'''

url = 'http://nginx.org/download/nginx-' + input_version + '.tar.gz'

wsl.download_src(url, 'nginx-1.13.11.tar.gz', 'nginx-1.13.11')

os.system(sudo_cmd + 'apt update')

cmd = sudo_cmd + '''apt install -y libpcre3 \
                                   openssl \
                                   zlib1g
'''

wsl.install_dep(cmd)

cmd = sudo_cmd + '''apt install gcc \
                                g++ \
                                libc6-dev \
                                zlib1g-dev \
                                libssl-dev \
                                libpcre3-dev
'''

wsl.install_build_dep(cmd)

configure_cmd = '''./configure --prefix={nginx_prefix} \
                       --conf-path={nginx_conf_dir}/nginx.conf \
                       --sbin-path=/usr/local/sbin/nginx \
                       --modules-path=/usr/local/nginx/modules \
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
                       --with-compat \
                       --with-file-aio \
                       --with-threads \
                       --with-http_addition_module \
                       --with-http_auth_request_module \
                       --with-http_dav_module \
                       --with-http_flv_module \
                       --with-http_gunzip_module \
                       --with-http_gzip_static_module \
                       --with-http_mp4_module \
                       --with-http_random_index_module \
                       --with-http_realip_module \
                       --with-http_secure_link_module \
                       --with-http_slice_module \
                       --with-http_ssl_module \
                       --with-http_stub_status_module \
                       --with-http_sub_module \
                       --with-http_v2_module \
                       --with-mail \
                       --with-mail_ssl_module \
                       --with-stream \
                       --with-stream_realip_module \
                       --with-stream_ssl_module \
                       --with-stream_ssl_preread_module
'''.format(nginx_prefix=nginx_prefix, nginx_conf_dir=nginx_conf_dir)

bin_cmd = 'echo "do nothing"'

wsl.builder('nginx-1.13.11', configure_cmd, sudo_cmd, bin_cmd)

nginx_conf()
nginx_conf_d()
