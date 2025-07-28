#!/bin/bash

USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f2)
LOGFILES=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

VALIDATE_FUN(){
    if [ $1 -ne 0 ]
    then
        echo "$2 is FAILURE"
        exit 1
    else
        echo "$2 is SUCCESS"
    fi
}


if [ $USER_ID -eq 0 ]
then 
    echo "This is SUPER USER GO TO INSTALL PACKAGES"
else
    echo "THIS IS NOT SUPER USER PLEASE STOP OF THIS TO INSTALL PACKAGES"
    exit 1
fi

dnf install mysql-server -y &>>LOGFILES
VALIDATE_FUN $? "INSTALLING MYSQL PACKAGE"

systemctl enable mysqld &>>LOGFILES
VALIDATE_FUN $? "Mysql system enabaled"

systemctl start mysqld &>>LOGFILES
VALIDATE_FUN $? "Mysql is start"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOGFILES
VALIDATE_FUN $? "Password setup to enter the db"