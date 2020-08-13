#!/bin/bash
SSL_CA=${SSL_CA:-}
SSL_CERT=${SSL_CERT:-}
SSL_KEY=${SSL_KEY:-}
SSL_SKIP_VERIFY=${SSL_SKIP_VERIFY:-}
VERIFY=1

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage:"
    echo "  By default, it will bind mount to the Docker socket"
    echo "  To enable TLS, pass the SSL_CA, SSL_CERT and SSL_KEY environment"
    echo "  variables to the paths of the certificates."
    echo "  To disable SSL verification, set the SSL_SKIP_VERIFY env var"
    exit 1
fi

if [ ! -z "$SSL_SKIP_VERIFY" ]; then
    VERIFY=0
fi

echo "Listening on $PORT"
if [ ! -z "$SSL_CA" ] && [ ! -z "$SSL_CERT" ] && [ ! -z "$SSL_KEY" ]; then
    echo "Using TLS"
    socat openssl-listen:$PORT,reuseaddr,cert=$SSL_CERT,key=$SSL_KEY,cafile=$SSL_CA,verify=$VERIFY,fork UNIX-CONNECT:/var/run/docker.sock
else
    socat TCP-LISTEN:$PORT,fork UNIX-CONNECT:/var/run/docker.sock
fi
