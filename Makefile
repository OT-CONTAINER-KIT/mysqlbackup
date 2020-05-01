test-db:
	docker rm -f test-mysql || true
	docker run -itd --name test-mysql -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7

build:
	docker build -t opstree/mysqlbackup:0.1 .

run-entrypoint:
	docker run --entrypoint /bin/bash -v ${PWD}/test/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -v ${PWD}/test/dbTest.sh:/scripts/dbTest.sh -it --rm --net test-mysql:db opstree/mysqlbackup:0.1

put-dummy-data:
	docker run -it --entrypoint /bin/bash -v ${PWD}/test/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -v ${PWD}/test/dbTest.sh:/scripts/dbTest.sh --rm  --net test-mysql:db opstree/mysqlbackup:0.1 -c "source /scripts/dbTest.sh; insertData"

backup:
	docker run -it  -v ${PWD}/test/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --rm --net test-mysql:db opstree/mysqlbackup:0.1 backup

clean-db:
	docker rm -f test-mysql || true
	docker run -itd --name test-mysql -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7

restore:
	docker run -it --rm  -v ${PWD}/test/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --net test-mysql:db opstree/mysqlbackup:0.1 restore latest

getBackupID:
	docker run -it --rm opstree/mysqlbackup:1.0 getBackupID

end-to-end-test:
	make build
	make test-db
	sleep 30s
	make put-dummy-data
	make backup
	make clean-db
	make restore
