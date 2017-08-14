#!/bin/bash

sudo apt-get update
sudo apt-get install postgresql ntp htop
sudo apt-get remove --purge rpcbind

sudo service ntp restart

read -p "add 'host   all    all   192.168.xxx.0/24  md5' to /etc/postgresql/x.x/main/pg_hba.conf" 
read -p "modify 'listen_addresses='localhost' to '*' in /etc/postgresql/x.x/main/postgresql.conf" 

# first set postgres password
# sudo -u postgres psql
# \password
#
# psql -h <host> -U <user> -d <database>
# \l                list databases
# \c                connect to database
# \d{t|i|s|v|S}     list tables/indexes/sequences/views/system tables
