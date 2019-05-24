#!/bin/bash
 
# Install database file
mysql_install_db --user mysql > /dev/null

# Create changing root password sql file
#cat > /tmp/sql <<EOF
#USE mysql;
#FLUSH PRIVILEGES;
#GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
#UPDATE user SET password=PASSWORD("password") WHERE user='root';
#EOF

# Change root password
#mysqld_safe --bootstrap --verbose=0 < /tmp/sql
#rm -rf /tmp/sql

#sleep 60

# Run mysql
/etc/init.d/commanderAgent start
mysqld_safe
