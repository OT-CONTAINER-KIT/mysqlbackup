test-db:
	docker rm -f test-mysql || true
	docker run -itd --name test-mysql -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7

build:
	docker build -t opstree/mysqlbackup:0.1 .

put-dummy-data:
	docker run -it  -v ${PWD}/sample/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --rm --net test-mysql:db opstree/mysqlbackup:0.1 writeData

get-dummy-data:
	docker run -it  -v ${PWD}/sample/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --rm --net test-mysql:db opstree/mysqlbackup:0.1 readData

clean-database:
	docker run -it  -v ${PWD}/sample/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --rm --net test-mysql:db opstree/mysqlbackup:0.1 cleanData

run-entrypoint:
	docker run --entrypoint /bin/bash -v ${PWD}/sample/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -it --net test-mysql:db --rm opstree/mysqlbackup:0.1

backup:
	docker run -it  -v ${PWD}/sample/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --rm --net test-mysql:db opstree/mysqlbackup:0.1 backup

restore:
	docker run -it --rm  -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/Common_SharedDir:/Common_SharedDir opstree/mysqlbackup:0.1 restore

getBackupID:
	docker run -it --rm opstree/mysqlbackup:1.0 getBackupID

end-to-end-test:
	make put-dummy-data
	make backup
	make clean-database
	make restore
	make get-dummy-data
