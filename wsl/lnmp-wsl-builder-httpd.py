#!/usr/bin/env python3

import os
import sys


def print_help_info():
    print('''

Usage:

$ lnmp-wsl-builder-httpd.py [HTTPD_VERSION] [SUDO_PASSWORD]

Example:

$ lnmp-wsl-builder-httpd.py 2.4.48 sudopasswd

  ''')


def download_src(version):
    os.chdir('/tmp')

    if os.path.exists('httpd-' + version):
        return 0
    elif os.path.exists('httpd-' + version + '.tar.gz'):
        os.system('tar -zxvf httpd-' + version + '.tar.gz')
        return 0

    url = 'http://mirrors.shu.edu.cn/apache/httpd/httpd-' + version + '.tar.gz'
    cmd = 'wget ' + url
    os.system(cmd)
    download_src(version)

def install_dep():
    cmd = sudo_cmd + '''apt-get install -y --no-install-recommends \
        libapr1 \
        libaprutil1 \
        libaprutil1-ldap \
        libapr1-dev \
        libaprutil1-dev \
        liblua5.2-0 \
        libnghttp2-14 \
        libpcre++0v5 \
        libssl1.0.2 \
        libxml2'''
    os.system(sudo_cmd + 'apt-get update && ' + cmd)
    pass


def install_build_dep():
    cmd = sudo_cmd + '''apt install -y bzip2 \
        ca-certificates \
        dpkg-dev \
        gcc \
        liblua5.2-dev \
        libnghttp2-dev \
        libpcre++-dev \
        libssl-dev \
        libxml2-dev \
        zlib1g-dev \
        make \
        wget'''
    os.system(cmd)


def builder(version):
    os.chdir('/tmp/httpd-' + version)
    cmd = '''./configure \
        --build=$( dpkg-architecture --query DEB_BUILD_GNU_TYPE ) \
        --prefix="/usr/local/httpd" \
        --bindir="/usr/local/bin" \
        --sbindir="/usr/local/sbin" \
        --sysconfdir="/usr/local/etc/httpd" \
        --enable-mods-shared=reallyall \
        --enable-mpms-shared=all
        '''
    os.system(cmd)
    os.system('make -j $( nproc )')
    os.system(sudo_cmd + 'make install')
    cmd = '''sed -ri \
        -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
        -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
        "/usr/local/etc/httpd/httpd.conf";
        '''
    os.system(sudo_cmd + cmd)
    # cmd = 'ln -sf /usr/local/httpd/bin/* /usr/local/bin'
    os.system(sudo_cmd + cmd)
    pass


def test():
    cmd = 'httpd -v'
    os.system(cmd)
    pass


'''

'''

input_sudo = ''
input_version = ''

if len(sys.argv) == 3:
    input_version = sys.argv[1]
    input_sudo = sys.argv[2]
else:
    print_help_info()
    exit(0)

sudo_cmd = 'echo ' + input_sudo + ' | sudo -S '

ret = os.system(sudo_cmd + 'ls > /dev/null 2>&1')

if ret != 0:
    print('\nsudo password is not correct\n')
    exit(1)

'''

'''

download_src(input_version)

install_dep()

install_build_dep()

builder(input_version)

test()
