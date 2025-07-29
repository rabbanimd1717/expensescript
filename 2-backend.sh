#!/bin/bash

#backend server

USER_ID=$(id -u)

VALIDATE_FUN(){
    if [ $1 -eq 0 ]
    then
        echo "$2 is SUCCESS"
    else
        echo "$2 is FAILURE"
    fi
}

if [ $USER_ID -eq 0 ]
then
    echo "Installing Package this is super user"
else
    echo "This is not super user please stop here"
fi

dnf module disable nodejs -y
VALIDATE_FUN $? "disable previous version nodejs"

dnf module enable nodejs:20 -y
VALIDATE_FUN $? "Enable nodejs version of 20"

dnf install nodejs -y
VALIDATE_FUN $? "Installing nodejs"

useradd expense
VALIDATE_FUN $? "user added"

mkdir -p /app
VALIDATE_FUN $? "directory created name is app"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE_FUN $? "Downloading application code"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip
VALIDATE_FUN $? "unzip the code of the file"

cd /app
npm install
VALIDATE_FUN $? "installing dependencies"

#cp /home/ec2-user/expense_script/backend.service /etc/systemd/system/backend.service


