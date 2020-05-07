source /etc/backup/db.default
source /etc/backup/db.properties

function genetareMyCnfFile(){
  ENTRY
  local decoded_mysqldump_password=$(echo ${mysqldump_password} | base64 -d )
  local decoded_mysql_restore_password=$(echo ${mysql_restore_password} | base64 -d )
cat > /etc/backup/my.cnf <<EOF
[mysqldump]
host = $mysql_host_address
port = $mysql_host_port
user = $mysqldump_user
password = $decoded_mysqldump_password

[mysql]
host = $mysql_host_address
port = $mysql_host_port
user = $mysql_restore_user
password = $decoded_mysql_restore_password
EOF
EXIT
}

function backupMysqlDB(){
  ENTRY
  local exec_command="mysqldump --defaults-file=/etc/backup/my.cnf --all-databases $backup_DB_name > /tmp/$backup_file_name"
  sh -c "$exec_command"
  if [ "$?" -ne "0" ]; then
    ERROR "Backup FAILED..!"
    exit 1
  else
    DEBUG "Backup SuccessFull..!"
  fi
  EXIT
}

function restoreMysqlDB(){
  ENTRY
  echo -n "Doing Restore"
  local exec_command="mysql --defaults-file=/etc/backup/my.cnf $backup_DB_name < /tmp/$backup_file_name"
  sh -c "$exec_command"
  if [ "$?" -ne "0" ]; then
    ERROR "Restore FAILED..!"
    exit 1
  else
    DEBUG "\nRestore SuccessFull..!"
  fi
  EXIT
}

function clearTraces(){
  ENTRY
  DEBUG "Removing temporarily generated MySQL conf file"
  rm -rf /etc/backup/my.cnf
  EXIT
}
