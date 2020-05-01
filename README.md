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
docker run -it  -v ${PWD}/db.properties:/etc/backup/db.properties -v ${PWD}/restic.properties:/etc/backup/restic.properties --rm --net <remote_mysql_db> opstree/mysqlbackup:0.1 <operation>

i.e
docker run -it  -v ${PWD}/db.properties:/etc/backup/db.properties -v ${PWD}/restic.properties:/etc/backup/restic.properties --rm --net test-mysql:db opstree/mysqlbackup:0.1 backup
```

* Restore Mysql Database:
For restore you need provide 1 inputs
  * Snapshot ID of backup

```
docker run -it --rm  -v ${PWD}/db.properties:/etc/backup/db.properties -v ${PWD}/restic.properties:/etc/backup/restic.properties --net <remote_mysql_db> opstree/mysqlbackup:0.1 <operation> <backup_ID>

i.e
docker run -it --rm  -v ${PWD}/db.properties:/etc/backup/db.properties -v ${PWD}/restic.properties:/etc/backup/restic.properties --net test-mysql:db opstree/mysqlbackup:0.1 restore latest
```
* Listing of backups
```
docker run -it --rm opstree/mysqlbackup:1.0 getBackupID
```  
## TODO
* Support environment variables
* Strengthen input validations

## Reference
* https://github.com/banzaicloud/docker-mysql-client
