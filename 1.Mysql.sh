#!/bin/bash

USER_ID=$(id -u)

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

dnf install mysql-server -y
VALIDATE_FUN $? "INSTALLING MYSQL PACKAGE"

systemctl enable mysqld
VALIDATE_FUN $? "Mysql system enabaled"

systemctl start mysqld
VALIDATE_FUN $? "Mysql is start"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE_FUN $? "Password setup to enter the db"