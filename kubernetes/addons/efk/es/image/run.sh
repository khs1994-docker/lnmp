set -ex

export NODE_NAME=${NODE_NAME:-${HOSTNAME}}
export NODE_MASTER=${NODE_MASTER:-true}
export NODE_DATA=${NODE_DATA:-true}
export HTTP_PORT=${HTTP_PORT:-9200}
export TRANSPORT_PORT=${TRANSPORT_PORT:-9300}
export MINIMUM_MASTER_NODES=${MINIMUM_MASTER_NODES:-2}

chown -R elasticsearch:elasticsearch /data

./bin/elasticsearch_logging_discovery >> ./config/elasticsearch.yml
exec su elasticsearch -c /usr/local/bin/docker-entrypoint.sh
