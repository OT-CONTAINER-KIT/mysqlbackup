function generateCnf() {
  echo "Generating mysql conf file"
cat > /tmp/my.cnf <<EOF
[mysql]
host = db
port = 3306
user = root
password = password
EOF
}

function executeCommand(){
  generateCnf
  local exec_command=$1
  echo "Executing command $exec_command"
  mysql --defaults-file=/tmp/my.cnf  -e "$exec_command"
  return $?
}

function insertData() {
  echo -n "Writing Data to DB"
  local command="CREATE DATABASE dummy"
  executeCommand "$command"
  if [ "$?" -ne "0" ]; then
      echo -n "Writing data to DB FAILED..!"
      exit 1
  else
      echo -e "\nWriting data to DB SuccessFull..!"
  fi
}

function validateData() {
  echo -n "Validating restore"
  generateCnf
  mysql --defaults-file=/tmp/my.cnf CREATE use dummy
}
