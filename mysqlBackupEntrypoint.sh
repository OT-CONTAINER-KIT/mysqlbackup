#!/bin/bash
source /scripts/mysqlbackup.sh
source /etc/backup/db.default
source /etc/backup/db.properties

genetareMyCnfFile
case $1 in
  backup)
    backupMysqlDB
    ./resticEntrypoint.sh backup /tmp $backup_file_name
    ;;
  restore)
    restoreMysqlDB
    ;;
  getBackupID)
    ./resticEntrypoint.sh list
    ;;
  *)
    echo -n "Please give valid input"
    exit 1
    ;;
esac
clearTraces
