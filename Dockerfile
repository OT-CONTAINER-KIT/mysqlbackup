From opstree/restic:0.1

LABEL VERSION=1.0 \
      ARCH=AMD64 \
      MAINTAINER="Vishal Raj" \
      DESCRIPTION="Mysql Backup - docker image created by Opstree Solutions"
USER root
RUN apk add --no-cache mysql-client

COPY db.default /etc/backup/
COPY mysqlbackup.sh /scripts/
RUN chown -R backup:backup /etc/backup/
COPY mysqlBackupEntrypoint.sh /mysqlBackupEntrypoint.sh
RUN chown -R backup:backup /mysqlBackupEntrypoint.sh

USER backup

ENTRYPOINT ["/bin/bash", "/mysqlBackupEntrypoint.sh"]
