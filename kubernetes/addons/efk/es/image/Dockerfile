FROM golang:1.17.5 AS builder
COPY elasticsearch_logging_discovery.go go.mod go.sum /
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -a -ldflags "-w" -o /elasticsearch_logging_discovery /elasticsearch_logging_discovery.go


FROM docker.elastic.co/elasticsearch/elasticsearch:7.16.2

VOLUME ["/data"]
EXPOSE 9200 9300

COPY --from=builder /elasticsearch_logging_discovery bin/
COPY run.sh bin/
COPY config/elasticsearch.yml config/log4j2.properties config/

USER root
RUN chown -R elasticsearch:elasticsearch ./
CMD ["bin/run.sh"]
