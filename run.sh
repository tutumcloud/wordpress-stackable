#!/bin/bash
if [ -f /.mysql_db_created ]; then
        exec supervisord -n
        exit 1
fi

if [[ $# -eq 0 ]]; then
        echo "Usage: $0 <db_name>"
        exit 1
fi

DB_EXISTS=$(mysql -uadmin -p$DB_PASSWORD -h$DB_PORT_3306_TCP_ADDR -P$DB_PORT_3306_TCP_PORT -e "SHOW DATABASES LIKE '"$1"';" | grep "$1" > /dev/null; echo "$?")

if [[ DB_EXISTS -eq 1 ]]; then
        echo "=> Creating database $1"
        RET=1
        while [[ RET -ne 0 ]]; do
                sleep 5
                mysql -uadmin -p$DB_PASSWORD -h$DB_PORT_3306_TCP_ADDR -P$DB_PORT_3306_TCP_PORT -e "CREATE DATABASE $1"
                RET=$?
        done
        echo "=> Done!"

        mysqladmin -uadmin -p$DB_PASSWORD -h$DB_PORT_3306_TCP_ADDR -P$DB_PORT_3306_TCP_PORT shutdown

fi

touch /.mysql_db_created
exec supervisord -n