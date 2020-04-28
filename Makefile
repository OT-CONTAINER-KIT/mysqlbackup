test-db:
	docker rm -f test-mysql || true
	docker run -itd --name test-mysql -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7

build:
	docker build -t opstree/mysqlbackup:0.1 .

run-entrypoint:
	docker run --entrypoint /bin/bash -v ${PWD}/sample/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -it --link test-mysql:db --rm opstree/mysqlbackup:0.1

nbackup:
	docker run -it  -v ${PWD}/sample/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --rm --link test-mysql:db opstree/mysqlbackup:0.1 backup

restore:
	docker run -it --rm  -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/Common_SharedDir:/Common_SharedDir opstree/mysqlbackup:0.1 restore

getBackupID:
	docker run -it --rm opstree/mysqlbackup:1.0 getBackupID
