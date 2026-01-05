#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


a=$(id -u)
if [ $a -ne 0 ]
then
    echo -e " $R You must be a root user"
    exit 1
fi

validate_check()
{
if [ $1 -ne 0 ]
then
    echo -e "$2  $R failed"
    exit 1
else
    echo -e "$2 $G successful"
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
