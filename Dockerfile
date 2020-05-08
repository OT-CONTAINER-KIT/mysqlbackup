FROM opstree/restic:0.2

LABEL VERSION=1.0 \
      ARCH=AMD64 \
      MAINTAINER="Vishal Raj" \
      DESCRIPTION="Mysql Backup - docker image created by Opstree Solutions"

USER root
RUN apk add --no-cache mysql-client

COPY ["db.default", "/etc/backup/"]
COPY ["scripts/", "/scripts/"]

RUN chown -R backup:backup /etc/backup/ /scripts

USER backup

ENTRYPOINT ["/bin/bash", "/scripts/mysqlBackupEntrypoint.sh"]
