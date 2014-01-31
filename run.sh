#!/bin/bash
if [ -f /.mysql_db_created ]; then
	exec supervisord -n
	exit 1
fi

if [[ $# -eq 0 ]]; then
	echo "Usage: $0 <db_name>"
	exit 1
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &

echo "=> Creating database $1"
RET=1
while [[ RET -ne 0 ]]; do
	sleep 5
	mysql -uadmin -p$DB_PASSWORD -h$DB_PORT_3306_TCP_ADDR -p$DB_PORT_3306_TCP_PORT -e "CREATE DATABASE $1"
	RET=$?
done

mysqladmin -uroot shutdown

echo "=> Done!"
touch /.mysql_db_created

exec supervisord -n

