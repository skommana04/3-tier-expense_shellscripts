#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#pwd=/home/ec2-user/3-tier-expense_shellscripts
project_adirectory=$(pwd)
a=$(id -u)
if [ $a -eq 0 ]
then
    echo -e " $G you are a root user $N"
else
    echo -e "you are not a root user $N"
    exit 1
fi

validate_check() 
{
    if [ $1 -eq 0 ]
    then
        echo -e " $G $2 successful $N"
    else
        echo -e " $R $2 failed $N"
    fi
}


dnf install nginx -y 
validate_check $? "nginx installation"

systemctl enable nginx
validate_check $? "nginx enable"


systemctl start nginx
validate_check $? "nginx start"

rm -rf /usr/share/nginx/html/*
validate_check $? "nginx html cleanup"

curl -o /tmp/frontend.zip https://expense-joindevops.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
validate_check $? "frontend code download"

cd /usr/share/nginx/html
validate_check $? "change directory to nginx html"

unzip /tmp/frontend.zip
validate_check $? "frontend code unzip"

cp $project_adirectory/expense.conf /etc/nginx/conf.d/expense.conf
validate_check $? "nginx configuration copy"

systemctl restart nginx
validate_check $? "nginx restart"