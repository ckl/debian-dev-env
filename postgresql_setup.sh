#!/bin/bash

sudo apt-get update
sudo apt-get install postgresql

read -p "add 'host   all    all   192.168.xxx.0/24  md5' to /etc/postgresql/x.x/main/pg_hba.conf" 
read -p "add 'local_address='*'' to /etc/postgresql/x.x/main/postgresql.conf" 

# psql -h <host> -U <user> -d <database>
# \l                list databases
# \c                connect to database
# \d{t|i|s|v|S}     list tables/indexes/sequences/views/system tables
