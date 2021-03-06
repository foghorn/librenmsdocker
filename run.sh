#Start the MySQL docker container
docker run \
        --name mysql \
        -d \
        -e MYSQL_ROOT_PASSWORD=letsgomets2019 \
        -p 127.0.0.1:3306:3306 \
        -v ~/docker/mysql:/var/lib/mysql \
        --restart always \
        mysql:5.6 --sql-mode=""

#Configure the MySQL database
#Copy the initial config script
docker cp dbinit.sh mysql:/usr/local/dbinit.sh
docker cp dbinit.sql mysql:/usr/local/dbinit.sql

#Set permissions and execute config script
docker exec mysql chmod +x /usr/local/dbinit.sh
docker exec -u root mysql /usr/local/dbinit.sh

#Start the LibreNMS container
docker run \
        -d \
        -h librenms \
        -p 80:80 \
        -p 161:161 \
        -p 162:162 \
        -p 514:514 -p 514:514/udp \
        --dns 8.8.8.8 \
        -e APP_KEY=base64:Q0+ZV56/5Uwz79vsvS4ZfwQFOty3e9DJEouEy+IXvz8= \
        -e DB_HOST=db \
        -e DB_NAME=librenms \
        -e DB_USER=librenms \
        -e DB_PASS=letsgomets2019 \
        -e BASE_URL=http://pinms:80 \
        -e ENABLE_SYSLOG=true \
        --link mysql:db \
        -v ~/docker/librenms/logs:/opt/librenms/logs \
        -v ~/docker/librenms/rrd:/opt/librenms/rrd \
        --name librenms \
        --restart always \
        jarischaefer/docker-librenms

#Configure the database and initial user
docker exec librenms setup_database
docker exec librenms create_admin
