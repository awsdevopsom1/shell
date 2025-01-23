source common.sh

if [ -z "$1" ]; then
  echo Password Input Missing
  exit
fi

MYSQL_ROOT_PASSWORD=$1



echo -e "${colour} Disable the default version \e[0m"
dnf module disable mysql -y  &>>$log_file
status_check


echo -e "${colour} installing the mysql \e[0m"
dnf install mysql-community-server -y
status_check

echo -e "${colour} copying the data \e[0m"
cp  mysql.repo  /etc/yum.repos.d/mysql.repo &>>$log_file
status_check

echo -e "${colour} setting the password for DB \e[0m"
mysql_secure_installation --set-root-pass ${MYSQL_ROOT_PASSWORD} 
status_check


echo -e "${colour} starting the mysql  service \e[0m"
systemctl enable mysqld
systemctl start mysqld 
status_check
