#!/bin/bash
apt update -y
apt install -y python3-dev python3-pip build-essential libssl-dev libffi-dev libmysqlclient-dev unzip libpq-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libffi-dev pkg-config mysql-client

pip3 install wtforms flask_mysqldb passlib

cd /home/ubuntu
wget https://tcb-bootcamps.s3.amazonaws.com/bootcamp-aws/en/wikiapp-en.zip
wget https://tcb-bootcamps.s3.amazonaws.com/bootcamp-aws/en/module3/dump-en.sql
unzip unzip /home/ubuntu/wikiapp-en.zip -d /home/ubuntu/wikiapp

# Wait for RDS to come online
until mysqladmin ping -h ${rds_endpoint} -u${db_username} -p${db_password} --silent; do
    echo "Waiting for RDS to be ready..."
    sleep 5
done

mysql -h ${rds_endpoint} -u ${db_username} -p${db_password} ${db_name} < dump-en.sql

cd wikiapp
python3 app.py &