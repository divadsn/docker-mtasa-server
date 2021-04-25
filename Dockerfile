FROM debian:buster-slim
LABEL maintainer="David Sn <divad.nnamtdeis@gmail.com>"

ARG USER=mtaserver
ARG UID=101
ARG GID=101

ENV MTA_SERVER_CONFIG_FILE=mtaserver.conf
ENV MTA_DEFAULT_RESOURCES_URL=http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip

ADD build.sh docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh && build.sh

USER ${USER}
EXPOSE 22003/udp 22005/tcp 22126/udp
WORKDIR /srv/multitheftauto_linux_x64
VOLUME ["/data", "/resources", "/resource-cache", "/native-modules"]

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["-x", "-n", "-u"]
