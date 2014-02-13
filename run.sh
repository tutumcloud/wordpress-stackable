#!/bin/bash
if [ -f /.mysql_db_created ]; 
then
        exec supervisord -n
        exit 1
fi

DB_EXISTS=$(mysql -uadmin -p$DB_PASSWORD -h$DB_PORT_3306_TCP_ADDR -P$DB_PORT_3306_TCP_PORT -e "SHOW DATABASES LIKE '"$WORDPRESS_DB_NAME"';" | grep "$WORDPRESS_DB_NAME" > /dev/null; echo "$?")

if [[ DB_EXISTS -eq 1 ]]; 
then
        echo "=> Creating database $WORDPRESS_DB_NAME"
        RET=1
        while [[ RET -ne 0 ]]; do
                sleep 5
                mysql -uadmin -p$DB_PASSWORD -h$DB_PORT_3306_TCP_ADDR -P$DB_PORT_3306_TCP_PORT -e "CREATE DATABASE $WORDPRESS_DB_NAME"
                RET=$?
        done
        echo "=> Done!"
else
        echo "=> Skipped creation of database $WORDPRESS_DB_NAME – it already exists."
fi

touch /.mysql_db_created
exec supervisord -n
