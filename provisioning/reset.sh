#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

mysql -udeployer -psecret -e "DROP DATABASE IF EXISTS deployer;"
mysql -udeployer -psecret -e "CREATE DATABASE deployer DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci;"
cd /var/www/deployer
php artisan app:reset
cd -

sudo cp /vagrant/provisioning/supervisor.conf /etc/supervisor/conf.d/deployer.conf
sudo cp /vagrant/provisioning/crontab /etc/cron.d/deployer
sudo cp /vagrant//provisioning/nginx.conf /etc/nginx/sites-available/deployer.conf

sudo service supervisor restart
redis-cli FLUSHALL
sudo service redis-server restart
sudo service beanstalkd restart
sudo service nginx restart

