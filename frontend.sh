source common.sh


echo -e "${colour} installing the nginx \e[0m"
dnf install nginx -y &>>$log_file
status_check

echo -e "${colour} copying the data \e[0m"
cp  expense.conf  /etc/nginx/default.d/expense.conf &>>log_file
status_check

echo -e "${colour} remove the old data \e[0m"
rm -rf /usr/share/nginx/html/* &>>$log_file
status_check

echo -e "${colour} download the content \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>log_file
status_check 

echo -e "${colour} Extract the downloaded application content \e[0m"
cd /usr/share/nginx/html &>>log_file
unzip /tmp/frontend.zip &>>log_file
status_check


echo -e "${colour} starting the nginx service \e[0m"
systemctl enable nginx 
systemctl restart nginx 
status_check

 

