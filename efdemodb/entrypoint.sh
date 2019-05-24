#!/bin/bash

/etc/init.d/commanderAgent start
 
# Install database file
mysql_install_db --user mysql > /dev/null

# Create changing root password sql file
cat > /tmp/sql <<EOF
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("1234") WHERE user='root';
EOF

# Change root password
mysqld --bootstrap --verbose=0 < /tmp/sql
rm -rf /tmp/sql

# Run mysql
mysqld

/etc/init.d/commanderAgent start && tail -F /opt/electriccloud/electriccommander/logs/agent/agent.log
