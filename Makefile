ifndef MYSQL_BACKUP_IMAGE_VERSION
override MYSQL_BACKUP_IMAGE_VERSION = 0.2
endif

test-db:
	docker rm -f test-mysql || true
	docker run -itd --rm --name test-mysql -e MYSQL_ROOT_PASSWORD=password mysql:5.7

build:
	docker build -t opstree/mysqlbackup:$(MYSQL_BACKUP_IMAGE_VERSION) .

run-entrypoint:
	docker run --entrypoint /bin/bash -v ${PWD}/test/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -v ${PWD}/test/dbTest.sh:/scripts/dbTest.sh -it --rm --link test-mysql:db opstree/mysqlbackup:$(MYSQL_BACKUP_IMAGE_VERSION)

put-dummy-data:
	docker run -it --entrypoint /bin/bash -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/test/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -v ${PWD}/test/dbTest.sh:/scripts/dbTest.sh --rm  --link test-mysql:db opstree/mysqlbackup:$(MYSQL_BACKUP_IMAGE_VERSION) -c "source /scripts/dbTest.sh; insertData"

backup:
	docker run -it -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/test/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --rm --link test-mysql:db opstree/mysqlbackup:$(MYSQL_BACKUP_IMAGE_VERSION) backup

clean-db:
	docker rm -f test-mysql || true
	docker run -itd --rm --name test-mysql -e MYSQL_ROOT_PASSWORD=password mysql:5.7

restore:
	docker run -it --rm  -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/test/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --link test-mysql:db opstree/mysqlbackup:$(MYSQL_BACKUP_IMAGE_VERSION) restore latest

getBackupID:
	docker run -it --rm -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/test/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties opstree/mysqlbackup:$(MYSQL_BACKUP_IMAGE_VERSION) getBackupID

end-to-end-test:
	make build
	make test-db
	sleep 30s
	make put-dummy-data
	make backup
	make clean-db
	make restore
