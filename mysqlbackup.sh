source /etc/backup/db.default
source /etc/backup/db.properties

function genetareMyCnfFile(){
  local decoded_mysqldump_password=$(echo ${mysqldump_password} | base64 -d )
cat > /etc/backup/my.cnf <<EOF
[mysqldump]
user = $mysqldump_user
password = $decoded_mysqldump_password
EOF
}

function backupMysqlDB(){
  echo -n "Taking Backup"
  local exec_command="mysqldump --defaults-file=/etc/backup/my.cnf --all-databases  -h $DB_HOST > /tmp/$backup_file_name"
  sh -c "$exec_command"
  if [ "$?" -ne "0" ]; then
    echo -n "Backup FAILED..!"
    exit 1
  else
    echo -e "\nBackup SuccessFull..!"
  fi
}

function restoreMysqlDB(){
  local exec_command="mysql --defaults-file=/etc/backup/my.cnf < /tmp/$backup_file_name"
  docker exec -i $mysqlDB_Container_id sh -c "$exec_command"
}

function clearTraces(){
  echo "Removing temporarily generated MySQL conf file"
  rm -rf /etc/backup/my.cnf
}
