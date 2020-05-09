# Mysql Backup and Restore

Docker wrapper over opstree/restic to manage backup/restore. Used Mysql-client tool for communicating with the remote mysql databases.
Currently below operations are supported:
* Backup
* Restore

## Repositories supported
This docker image supports below functionaly

Currently supported :
* Mysql full backup

Future support:
* Mysql incremental backup

## Backup & Restore DB Operation

```
docker run -it -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/test/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --rm --link test-mysql:db opstree/mysqlbackup:$(MYSQL_BACKUP_IMAGE_VERSION) backup
```

* Restore Mysql Database:
For restore you need to provide 1 input
  * Snapshot ID of backup

```
docker run -it --rm  -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/test/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --link test-mysql:db opstree/mysqlbackup:$(MYSQL_BACKUP_IMAGE_VERSION) restore latest
```
* Listing of backups
```
docker run -it --rm -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties opstree/mysqlbackup:$(MYSQL_BACKUP_IMAGE_VERSION) getBackupID
```  
## TODO
* Support environment variables
* Strengthen input validations

## Reference
* https://github.com/OT-CONTAINER-KIT/restic
