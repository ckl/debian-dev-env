#!/bin/bash
virtualenv -p /usr/bin/python3 $1
echo "source ./bin/activate" >> $1/.env
$1/bin/pip3 freeze > requirements.txt
