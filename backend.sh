#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


a=$(id -u)
if [ $a -ne 0 ]
then
    echo -e " $R You must be a root user $N"
    exit 1
fi

project_adirectory=$(pwd)
mkdir -p /var/log/backend_logs
log_dir="/var/log/backend_logs"
echo $project_adirectory
validate_check()
{
if [ $1 -ne 0 ]
then
    echo -e "$2  $R failed $N" | tee -a $log_dir/test.log 2>&1
    exit 1
else
    echo -e "$2 $G successful $N" | tee -a $log_dir/test.log 2>&1
fi

}

dnf module disable nodejs -y
validate_check $? "nodejs module disable"

dnf module enable nodejs:20 -y
validate_check $? "nodejs module enable"

dnf install nodejs -y
validate_check $? "nodejs installation"

grep expense /etc/passwd >/dev/null 2>&1
if [ $? -eq 0 ]
then
    echo -e "$G expense user already exists $N"
else
    useradd expense
    validate_check $? "expense user creation"
fi

mkdir /app
validate_check $? "app directory creation"

curl -o /tmp/backend.zip https://expense-joindevops.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
validate_check $? "backend code download"

cd /app
validate_check $? "change directory to /app"


echo $project_adirectory
project_adirectory=$(pwd)
echo $project_adirectory

unzip /tmp/backend.zip
validate_check $? "unzip backend code"

npm install
validate_check $? "npm install"   

cp $project_adirectory/backend.service /etc/systemd/system/
validate_check $? "copy backend service file"

systemctl daemon-reload
validate_check $? "daemon reload"

systemctl start backend
validate_check $? "backend service start"

systemctl enable backend
validate_check $? "backend service enable"

dnf install mysql -y
validate_check $? "mysql client installation"

mysql -h database.saidevops.site -uroot -pExpenseApp@1 < /app/schema/backend.sql
validate_check $? "database schema creation"

systemctl restart backend
validate_check $? "backend service restart"





