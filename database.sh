#!/bin/bash

a=$(id -u)
if [ $a -ne 0 ]
then
    echo "You must be a root user"
    exit 1
fi

validate_check()
{
if [ $1 -ne 0 ]
then
    echo "$2 failed"
    exit 1
else
    echo "$2 successful"
fi
}


#mysql server installation
dnf install mysql-server -y
vaidate_check $? "mysql installation"

#start mysql server
systemctl start mysqld
validate_check $? "mysql start"

#enable mysql server
systemctl enable mysqld
validate_check $? "mysql enable"

#secure mysql installation
mysql_secure_installation --set-root-pass ExpenseApp@1
validate_check $? "mysql secure installation"   
