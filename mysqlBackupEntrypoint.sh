#!/bin/bash
source /scripts/mysqlbackup.sh
source /etc/backup/db.default
source /etc/backup/db.properties
source /etc/backup/sanityTest.sh

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
  writeData)
    writeToDB
    ;;
  readData)
    readFromDB
    ;;    
  cleanData)
    cleanDB
    ;; 
  *)
    echo -n "Please give valid input"
    exit 1
    ;;
esac
clearTraces
