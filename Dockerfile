FROM agrozyme/alpine:3.11
COPY rootfs /
RUN set +e -uxo pipefail && chmod +x /usr/local/bin/* && /usr/local/bin/docker-build.lua
EXPOSE 8086
CMD ["/usr/local/bin/docker-run.lua"]
