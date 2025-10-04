#!/bin/sh

# 判断 IP 函数 http://www.jb51.net/article/48045.htm

CheckIPAddr()
{
echo $1|grep "^[0-9]\{1,3\}\.\([0-9]\{1,3\}\.\)\{2\}[0-9]\{1,3\}$" > /dev/null;
#IP地址必须为全数字
        if [ $? -ne 0 ];then return 1; fi
        ipaddr=$1
        a=`echo $ipaddr|awk -F . '{print $1}'`  #以"."分隔，取出每个列的值
        b=`echo $ipaddr|awk -F . '{print $2}'`
        c=`echo $ipaddr|awk -F . '{print $3}'`
        d=`echo $ipaddr|awk -F . '{print $4}'`
        for num in $a $b $c $d
        do
                if [ $num -gt 255 ] || [ $num -lt 0 ];then return 1; fi
        done
                return 0
}

ca_root(){
  cd /srv
  echo "[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash" > root-ca.cnf

  openssl genrsa -out "root-ca.key" 4096 \

  openssl req \
             -new -key "root-ca.key" \
             -out "root-ca.csr" -sha256 \
             -subj '/C=CN/ST=Shanxi/L=Datong/O=AAAA-khs1994.com/CN=khs1994.com ROOT CA/OU=www.khs1994.com' \

  openssl x509 -req  -days 3650  -in "root-ca.csr" \
             -signkey "root-ca.key" -sha256 -out "root-ca.crt" \
             -extfile "root-ca.cnf" -extensions \
             root_ca
}

case "$1" in
  sh | bash )
    exec /bin/sh
    exit 0
    ;;

  root_ca )
    ca_root
    exec cp /srv/root-ca.crt /srv/root-ca.key /ssl
    ;;

   help )
   exec echo "输出帮助信息

$ docker run -it --rm -v \$PWD/ssl:/ssl khs1994/tls help

自行签发证书

$ docker run -it --rm -v \$PWD/ssl:/ssl khs1994/tls khs1994.com

$ docker run -it --rm -v \$PWD/ssl:/ssl khs1994/tls khs1994.com *.khs1994.com t.khs1994.com *.t.khs1994.com 192.168.199.100 127.0.0.1 localhost...

生成 ROOT CA (非专业人员请谨慎使用)

$ docker run -it --rm -v \$PWD/ssl:/ssl khs1994/tls root_ca
"
;;
esac

if ! [ -f /srv/root-ca.crt ];then echo "ROOT CA ERROR"; exit 1;fi
if ! [ -f /srv/root-ca.key ];then echo "ROOT CA ERROR"; exit 1;fi

# sed -i "s/DOMAIN/${DOMAIN}/g" /srv/site.cnf
# sed -i "s/SITE_IP/${SITE_IP}/g" /srv/site.cnf

str=''

for input in "$@"
do
  CheckIPAddr $input
  if [ $? = 0 ];then
    str="${str}, IP:$input"
  else
    str="${str}, DNS:$input"
  fi
done

str=`echo $str | sed 's#^..##'`

echo "subjectAltName = $str"

echo "subjectAltName = $str" >> /srv/site.cnf

# rsa
openssl genrsa -out "/ssl/$1.rsa.key" 4096

openssl req -new -key "/ssl/$1.rsa.key" -out "/ssl/site.csr" -sha256 \
         -subj "/C=CN/ST=Shanxi/L=Datong/O=Your Company Name/CN=$1"

openssl x509 -req -days 750 -in "/ssl/site.csr" -sha256 \
         -CA "/srv/root-ca.crt" -CAkey "/srv/root-ca.key"  -CAcreateserial \
         -out "/ssl/$1.rsa.crt" -extfile "/srv/site.cnf" -extensions server

# ecc
openssl ecparam -genkey -name prime256v1 -out "/ssl/$1.key"

openssl req -new -key "/ssl/$1.key" -out "/ssl/site.csr" -sha256 \
         -subj "/C=CN/ST=Shanxi/L=Datong/O=Your Company Name/CN=$1"

openssl x509 -req -days 750 -in "/ssl/site.csr" -sha256 \
         -CA "/srv/root-ca.crt" -CAkey "/srv/root-ca.key"  -CAcreateserial \
         -out "/ssl/$1.crt" -extfile "/srv/site.cnf" -extensions server


cp /srv/root-ca.crt /ssl

rm -rf /ssl/*.csr
