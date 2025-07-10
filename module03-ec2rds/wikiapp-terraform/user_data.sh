#!/bin/bash
set -e

echo "===== Updating and installing system dependencies ====="
apt-get update -y
apt-get install -y python3-dev python3-pip build-essential libssl-dev libffi-dev \
                   libmysqlclient-dev unzip libpq-dev libxml2-dev libxslt1-dev \
                   libldap2-dev libsasl2-dev pkg-config mysql-client netcat

echo "===== Installing Python packages ====="
pip3 install wtforms flask_mysqldb passlib

echo "===== Switching to /home/ubuntu ====="
cd /home/ubuntu

echo "===== Downloading application files ====="
wget https://tcb-bootcamps.s3.amazonaws.com/bootcamp-aws/en/wikiapp-en.zip
wget https://tcb-bootcamps.s3.amazonaws.com/bootcamp-aws/en/module3/dump-en.sql

echo "===== Unzipping wikiapp ====="
unzip /home/ubuntu/wikiapp-en.zip -d /home/ubuntu

echo "===== Checking RDS connectivity on port 3306 ====="
MAX_ATTEMPTS=60
ATTEMPT=0

while ! nc -zv ${rds_endpoint} 3306; do
    echo "[$(date)] Waiting for RDS to accept connections on port 3306... attempt $((++ATTEMPT))/$MAX_ATTEMPTS"
    sleep 10
    if [ $ATTEMPT -ge $MAX_ATTEMPTS ]; then
        echo "RDS not reachable after $MAX_ATTEMPTS attempts. Exiting."
        exit 1
    fi
done

echo "===== RDS is reachable. Seeding database ====="
mysql -h "${rds_endpoint}" -u "${db_username}" -p"${db_password}" "${db_name}" < /home/ubuntu/dump-en.sql

mysql -h ${rds_endpoint} -u ${db_username} -p${db_password} <<EOF
CREATE USER IF NOT EXISTS 'wiki'@'%' IDENTIFIED BY 'wiki123456';
GRANT ALL PRIVILEGES ON ${db_name}.* TO 'wiki'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "===== Update wikiapp configuration with RDS Endpoint ====="
sed -i "s/app.config\['MYSQL_HOST'\] = .*/app.config['MYSQL_HOST'] = '${rds_endpoint}'/" /home/ubuntu/wikiapp/wiki.py

echo "===== Starting wikiapp ====="
cd /home/ubuntu/wikiapp
nohup python3 app.py > /home/ubuntu/wikiapp.log 2>&1 &
echo "===== Wikiapp started successfully ====="