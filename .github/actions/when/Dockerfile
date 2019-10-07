FROM khs1994/php:7.3.10-composer-alpine

ENV PCIT_WHEN_COMMIT_MESSAGE=1
# ENV PCIT_WHEN_BRANCH=master
# ENV PCIT_WHEN_COMMIT_MESSAGE_SKIP="skip sync"
# ENV PCIT_WHEN_COMMIT_MESSAGE_INCLUDE="sync php"

COPY docker-entrypoint.sh /

ENTRYPOINT ["sh","/docker-entrypoint.sh"]
