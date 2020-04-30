test-db:
	docker rm -f test-mysql || true
	docker run -itd --name test-mysql -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7

build:
	docker build -t opstree/mysqlbackup:0.1 .

run-entrypoint:
	docker run --entrypoint /bin/bash -v ${PWD}/sample/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -v ${PWD}/sample/dbTest.sh:/scripts/dbTest.sh -it --link test-mysql:db --rm opstree/mysqlbackup:0.1

put-dummy-data:
	docker run -it --entrypoint /bin/bash -v ${PWD}/sample/db.properties:/etc/backup/db.properties -v ${PWD}/sample/dbTest.sh:/scripts/dbTest.sh --rm --link test-mysql:db opstree/mysqlbackup:0.1 "source /scripts/dbTest.sh; insertData"

get-dummy-data:
	docker run -it  -v ${PWD}/sample/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --rm --net local test-mysql:db opstree/mysqlbackup:0.1 mysql sh -c 'echo "[client]\nuser=\"$MYSQL_USER\"\n password=\"$MYSQL_PASSWORD\"\nhost=\"$MYSQL_HOST_IP\"\nport=\"$MYSQL_HOST_PORT\"" > /tmp/my.cnf && exec mysql --defaults-file=/tmp/my.cnf USE dumy'

clean-database:
	docker run -it  -v ${PWD}/sample/db.properties:/etc/backup/db.properties -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties --rm --net test-mysql:db opstree/mysqlbackup:0.1 mysql sh -c 'echo "[client]\nuser=\"$MYSQL_USER\"\n password=\"$MYSQL_PASSWORD\"\nhost=\"$MYSQL_HOST_IP\"\nport=\"$MYSQL_HOST_PORT\"" > /tmp/my.cnf && exec mysql --defaults-file=/tmp/my.cnf DROP DATABASES dummy'


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
	make clean-database
