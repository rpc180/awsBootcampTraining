#!/bin/bash
apt update -y
apt install -y python3 python3-devel python3-pip gcc gcc-c++ make openssl-devel libffi-devel                mysql-devel postgresql-devel libxml2-devel libxslt-devel openldap-devel                cyrus-sasl-devel pkgconfig mysql unzip

pip3 install flask flask_mysqldb passlib

cd /home/ubuntu
unzip /tmp/wikiapp-en.zip -d wikiapp
unzip /tmp/init.sql.zip -d wikiapp

# Wait for RDS to come online
sleep 60

mysql -h ${rds_endpoint} -u ${db_username} -p${db_password} ${db_name} < wikiapp/init.sql

cd wikiapp
python3 app.py &