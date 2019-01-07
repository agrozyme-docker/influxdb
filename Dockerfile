FROM agrozyme/alpine:3.8

RUN set -euxo pipefail \
  && apk add --no-cache influxdb

EXPOSE 8086 8083 2003
CMD ["influxd"]
