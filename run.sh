#!/bin/bash
if [ -f /.mysql_db_created ]; then
        exec supervisord -n
        exit 1
fi

if [[ $# -eq 0 ]]; then
        echo "Usage: $0 <db_name>"
        exit 1
fi

TABLE_EXISTS=$(mysql -uadmin -p$DB_PASSWORD -h$DB_PORT_3306_TCP_ADDR -P$DB_PORT_3306_TCP_PORT -e "USE $1")

if [[ TABLE_EXISTS -eq 1 ]]; then
        echo "=> Creating database $1"
        RET=1
        while [[ RET -ne 0 ]]; do
                sleep 5
                mysql -uadmin -p$DB_PASSWORD -h$DB_PORT_3306_TCP_ADDR -P$DB_PORT_3306_TCP_PORT -e "CREATE DATABASE $1"
                RET=$?
        done
        echo "=> Done!"
fi

touch /.mysql_db_created
exec supervisord -n