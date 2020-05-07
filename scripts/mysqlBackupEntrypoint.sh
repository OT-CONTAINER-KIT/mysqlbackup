#!/bin/bash
source /scripts/mysqlbackup.sh
source /etc/backup/db.default
source /etc/backup/db.properties
source /scripts/logging.sh
SCRIPTENTRY

genetareMyCnfFile
case $1 in
  backup)
    backupMysqlDB
    /scripts//resticEntrypoint.sh backup /tmp $backup_file_name
    ;;
  restore)
    /scripts/resticEntrypoint.sh restore $2 /tmp
    restoreMysqlDB
    ;;
  getBackupID)
    /scripts/resticEntrypoint.sh list
    ;;
  *)
    echo -n "Please give valid input"
    exit 1
    ;;
esac
clearTraces
