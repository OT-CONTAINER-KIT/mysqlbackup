source /etc/backup/db.default
source /etc/backup/db.properties

function genetareMyCnfFile(){
  local decoded_mysqldump_password=$(echo ${mysqldump_password} | base64 -d )
cat > /etc/backup/my.cnf <<EOF
[mysqldump]
host = $mysql_host_address
port = $mysql_host_port
user = $mysqldump_user
password = $decoded_mysqldump_password
EOF
}

function backupMysqlDB(){
  echo -n "Taking Backup"
  local exec_command="mysqldump --defaults-file=/etc/backup/my.cnf --all-databases $backup_DB_name > /tmp/$backup_file_name"
  sh -c "$exec_command"
  if [ "$?" -ne "0" ]; then
    echo -n "Backup FAILED..!"
    exit 1
  else
    echo -e "\nBackup SuccessFull..!"
  fi
}

function restoreMysqlDB(){
  echo -n "Doing Restore"
  local exec_command="mysql --defaults-file=/etc/backup/my.cnf $backup_DB_name < /tmp/$backup_file_name"
  sh -c "$exec_command"
  if [ "$?" -ne "0" ]; then
    echo -n "Restore FAILED..!"
    exit 1
  else
    echo -e "\nRestore SuccessFull..!"
  fi
}

function clearTraces(){
  echo "Removing temporarily generated MySQL conf file"
  rm -rf /etc/backup/my.cnf
}
