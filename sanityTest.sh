#!/bin/bash

function executeCommand(){
    local exec_command=$1
    sh -c "mysql --defaults-file=/etc/backup/my.cnf $exec_command"
    return $?
}

function writeToDB(){
    echo -n "Writing Data to DB"
    local command="CREATE DATABASE dummy"
    executeCommand $command
    if [ "$?" -ne "0" ]; then
        echo -n "Writing data to DB FAILED..!"
        exit 1
    else
        echo -e "\nWriting data to DB SuccessFull..!"
    fi
}

function readFromDB(){   
    echo -n "Reading Data to DB"
    local command="USE dummy"
    executeCommand $command
    if [ "$?" -ne "0" ]; then
        echo -n "Reading data to DB FAILED..!"
        exit 1
    else
        echo -e "\nReading data to DB SuccessFull..!"
    fi
}

function cleanDB(){  
    echo -n "Clean Entry from DB"
    local command="DROP DATABASE dummy"
    executeCommand $command
    if [ "$?" -ne "0" ]; then
        echo -n "Clean Entry from DB FAILED..!"
        exit 1
    else
        echo -e "\nClean Entry from DB SuccessFull..!"
    fi
}