FROM alpine:latest

ADD entrypoint.sh /opt/entrypoint.sh
ADD yar2v.zip /opt/yar2v.zip

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && chmod +x /opt/entrypoint.sh

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]
