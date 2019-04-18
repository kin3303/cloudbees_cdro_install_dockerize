for filename in  /var/lib/mysql/backup/*-ecdb.sql.gz; do
  gunzip < $dir/$filename | mysql -h db -u ecdb -pecdb "ecdb"
done 


