source common.sh

if [ -z "$1" ]; then
  echo Password Input Missing
  exit
fi

MYSQL_ROOT_PASSWORD=$1

echo -e "${colour} disable and enable \e[0m"
dnf module disable nodejs -y &>>$log_file
status_check

echo -e "${colour} enable nodejs \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
status_check

echo -e "${colour} enable nodejs \e[0m"
dnf install nodejs -y &>>$log_file
status_check

echo -e "${colour} copying the data \e[0m"
cp  backend.service /etc/systemd/system/backend.service &>>$log_file
status_check

id expense &>>$log_file
if [ $? -ne 0 ]; then
  echo -e "${color} Add Application User \e[0m"
  useradd expense &>>$log_file
  status_check
fi

if [ ! -d /app ]; then
  echo -e "${color} Create Application Directory \e[0m"
  mkdir /app &>>$log_file
  status_check
fi


echo -e "${color} Delete old Application Content \e[0m"
rm -rf /app/* &>>$log_file
status_check


echo -e "${colour} download the content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
status_check 

echo -e "${colour} Extract the downloaded application content \e[0m"
cd /app  &>>$log_file
unzip /tmp/backend.zip &>>$log_file
status_check
echo -e "${colour} installing the node js\e[0m"
npm install  &>>$log_file
status_check

echo -e "${color} Install MySQL Client to Load Schema \e[0m"
dnf install mysql -y &>>$log_file
status_check

echo -e "${color} Load Schema \e[0m"
mysql -h 172.31.86.200 -uroot -p${MYSQL_ROOT_PASSWORD} < /app/schema/backend.sql  
status_check

echo -e "${colour} starting the backendservice \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl start backend &>>$log_file
status_check






