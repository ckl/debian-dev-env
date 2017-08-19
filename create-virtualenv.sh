#!/bin/bash
virtualenv -p /usr/bin/python3 $1
cp ~/gitrepos/debian-dev-env/env-project.sh $1/.env
$1/bin/pip3 freeze > $1/requirements.txt
