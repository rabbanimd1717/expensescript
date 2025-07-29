# #!/bin/bash

# #backend server

# USER_ID=$(id -u)
# TIMESTAMP=$(date +%F-%H-%M-%S)
# SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
# LOGFILES=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

# echo "Please tnter the password"
# read -s password

# #colors
# R="\e[31m"
# G="\e[32m"
# Y="\e[33m"
# N="\e[0m"

# VALIDATE_FUN(){
#     if [ $1 -eq 0 ]
#     then
#         echo -e "$2 is $G SUCCESS $N"
#     else
#         echo -e "$2 is $R FAILURE $N"
#     fi
# }

# if [ $USER_ID -eq 0 ]
# then
#     echo -e " $Y Installing Package this is super user $N"
# else
#     echo -e "$R This is not super user please stop here $N"
# fi

# dnf module disable nodejs -y &>>$LOGFILES
# VALIDATE_FUN $? "disable previous version nodejs"

# dnf module enable nodejs:20 -y &>>$LOGFILES
# VALIDATE_FUN $? "Enable nodejs version of 20"

# dnf install nodejs -y &>>$LOGFILES
# VALIDATE_FUN $? "Installing nodejs"

# #useradd expense
# id expense &>>$LOGFILES
# if [ $? -eq 0 ]
# then
#     echo -e "$G user already existing then $Y skipping $N"
# else
#     useradd expense
#     VALIDATE_FUN $? "user added"
# fi

# mkdir -p /app
# VALIDATE_FUN $? "directory created name is app"

# curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILES
# VALIDATE_FUN $? "Downloading application code"

# cd /app
# rm -rf /app/*

# unzip /tmp/backend.zip &>>$LOGFILES
# VALIDATE_FUN $? "unzip the code of the file"

# cd /app
# npm install &>>$LOGFILES
# VALIDATE_FUN $? "installing dependencies"

# cp /home/ec2-user/expensescript/backend.service /etc/systemd/system/backend.service
# VALIDATE_FUN $? "copy to absolute path"

# systemctl daemon-reload &>>$LOGFILES
# systemctl start backend &>>$LOGFILES
# systemctl enable backend &>>$LOGFILES
# VALIDATE_FUN $? "system reload, start and enable"

# dnf install mysql -y &>>$LOGFILES
# VALIDATE_FUN $? "Installing mysql client to connect db from backend"

# mysql -h 172.31.45.100 -uroot -p${password} < /app/schema/backend.sql &>>$LOGFILES
# VALIDATE_FUN $? "schema loading"

# systemctl restart backend &>>$LOGFILES
# VALIDATE_FUN $? "restart the backend service"


#!/bin/bash

USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "-" -f2)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "enter secret password of mysql"
read -s mysqlpassword

VALIDATE_FUN(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R FAILURE $N"
        exit 1
    else
        echo -e "$2 is $G SUCCESS $N"
    fi
}

if [ $USER_ID -ne 0 ]
then
    echo "NEED TO DO WITH SUPER USER DOWNLOAD THIS PACKAGE"
    exit 1
else
    echo "THIS IS SUPER USER INSTALLING PACKAGE WITHOUT INTERUPPTIONS"
fi

dnf module disable nodejs -y &>>$LOG_FILE

VALIDATE_FUN $? "DISABLING NODEJS"

dnf module enable nodejs:20 -y &>>$LOG_FILE

VALIDATE_FUN $? "ENABLING NODEJS"

dnf install nodejs -y &>>$LOG_FILE

VALIDATE_FUN $? "INSTALLING NODEJS"

id expense &>>$LOG_FILE

if [ $? -ne 0 ]
then
    useradd expense &>>$LOG_FILE
    VALIDATE_FUN $? "USER CREATING"
else
    echo -e "$G USER ALREADY EXISTING $Y SKIPPING $N"
fi

mkdir -p /app &>>$LOG_FILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>> $LOG_FILE

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE_FUN $? "UNZIP THE FILE"

npm install &>>$LOG_FILE
VALIDATE_FUN $? "NPM DEPENDENCIES INSTALLING"

cp /home/ec2-user/expense_script/backend.service /etc/systemd/system/backend.service
VALIDATE_FUN $? "COPIED backend.service"

systemctl daemon-reload &>>$LOG_FILE

systemctl start backend &>>$LOG_FILE

systemctl enable backend &>>$LOG_FILE
VALIDATE_FUN $? "daemon reload, start and enable successfully"

dnf install mysql -y &>> $LOG_FILE
VALIDATE_FUN $? "INSTALL MYSQL IN BACKEND SCRIPT"

mysql -h 172.31.45.100 -uroot -p${mysqlpassword} < /app/schema/backend.sql &>>$LOG_FILE
VALIDATE_FUN $? "attach the mysql with backend"

systemctl restart backend &>>$LOG_FILE
VALIDATE_FUN $? "Restarting the backend"

dnf install git -y &>>$LOG_FILE
VALIDATE_FUN $? "INSTALLIN GIT"


