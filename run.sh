#!/bin/bash
if [ -f /.mysql_db_created ]; 
then
        exec supervisord -n
        exit 1
fi

for ((i=0;i<10;i++))
do
	DB_CONNECTABLE=$(mysql -u$WORDPRESS_DB_USER -p$WORDPRESS_DB_PASS -h$DB_1_PORT_3306_TCP_ADDR -P$DB_1_PORT_3306_TCP_PORT -e 'status' >/dev/null 2>&1; echo "$?")
    if [[ DB_CONNECTABLE -eq 0 ]];
	then
		break
	fi
	sleep 5
done

if [[ $DB_CONNECTABLE -eq 0 ]];
then 
	DB_EXISTS=$(mysql -u$WORDPRESS_DB_USER -p$WORDPRESS_DB_PASS -h$DB_1_PORT_3306_TCP_ADDR -P$DB_1_PORT_3306_TCP_PORT -e "SHOW DATABASES LIKE '"$WORDPRESS_DB_NAME"';" 2>&1 |grep "$WORDPRESS_DB_NAME" > /dev/null ; echo "$?")
	
	if [[ DB_EXISTS -eq 1 ]];
	then
		echo "=> Creating database $WORDPRESS_DB_NAME"
		RET=$(mysql -u$WORDPRESS_DB_USER -p$WORDPRESS_DB_PASS -h$DB_1_PORT_3306_TCP_ADDR -P$DB_1_PORT_3306_TCP_PORT -e "CREATE DATABASE $WORDPRESS_DB_NAME")
		if [[ RET -ne 0 ]];
		then 
			echo "Cannot create database for wordpress"
			exit RET
		fi
		echo "=> Done!"	
	else
		echo "=> Skipped creation of database $WORDPRESS_DB_NAME – it already exists."
	fi
else
	echo "Cannot connect to Mysql"
	exit $DB_CONNECTABLE
fi

touch /.mysql_db_created
exec supervisord -n
