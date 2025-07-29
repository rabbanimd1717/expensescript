#!/bin/bash

# USER_ID=$(id -u)
# TIMESTAMP=$(date +%F-%H-%M-%S)
# SCRIPTING_NAME=$(echo $0 | cut -d "." -f2)
# LOG_FILE=/tmp/$SCRIPTING_NAME-$TIMESTAMP.log

# R="\e[31m"
# G="\e[32m"
# Y="\e[33m"
# N="\e[0m"
# echo "Please enter DB secure password"
# read -s DB_PASSWORD

# VALIDATE_FUN(){
#     if [ $1 -ne 0 ]
#     then
#         echo -e "$2 is $R FAILURE $N"
#         exit 1
#     else
#         echo -e "$2 is $G SUCCESS $N"
#     fi
# }

# if [ $USER_ID -eq 0 ]
# then
#     echo -e "$Y INSTALLING PACKAGE $N"
# else
#     echo "NEED TO SUDO USER FOR THIS PACKAGE INSTALLATION"
#     exit 1
# fi


# dnf install mysql-server -y >> $LOG_FILE

# VALIDATE_FUN $? "INSTALLING MYSQL"

# systemctl enable mysqld >> $LOG_FILE

# VALIDATE_FUN $? "ENABLED MYSQL"

# systemctl start mysqld >> $LOG_FILE

# VALIDATE_FUN $? "START MYSQL"

# # mysql_secure_installation --set-root-pass ExpenseApp@1 >> $LOG_FILE

# mysql -h 172.31.45.100 -uroot -p${DB_PASSWORD} -e 'SHOW DATABASES;'

# if [ $? -eq 0 ]
# then
#     echo "already setup"
# else
#     mysql_secure_installation --set-root-pass ${DB_PASSWORD} &>> $LOG_FILE
#     VALIDATE_FUN $? "SETUP ROOT PASSWORD"
# fi

# mkdir -p rabbani
#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "Please enter DB password:"
read -s mysql_root_password

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQL Server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
mysql -h 172.31.45.100 -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi