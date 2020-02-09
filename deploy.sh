#!/bin/bash
set -e

now=$(date +%Y%m%d-%H%M%S)
if [[ -f "/var/log/nginx/access.log" ]]; then
    sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.$now
fi
if [[ -f "/var/log/mysql/slow.log" ]]; then
    sudo mv /var/log/mysql/slow.log /var/log/mysql/slow.log.$now
fi

sudo mysqladmin -uisucon -pisucon flush-logs

# copy etc
sudo cp ./etc/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp ./etc/systemd/system/torb.python.service /etc/systemd/system/torb.python.service 
sudo cp ./etc/my.cnf /etc/my.cnf

# restart
sudo systemctl daemon-reload
sudo systemctl reload nginx

sudo systemctl restart mariadb
sudo systemctl restart nginx
sudo systemctl restart torb.python

sudo journalctl -f