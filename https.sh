docker run \
	-d \
	-h librenms \
	--expose 80:80 \
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
	-v /home/foghorn/docker/librenms/logs:/opt/librenms/logs \
	-v /home/foghorn/docker/librenms/rrd:/opt/librenms/rrd \
	--name librenms \
	--restart always \
	jarischaefer/docker-librenms

docker run \
    -d \
    --name nginx \
    --link librenms \
    -e UPSTREAM=librenms:80 \
    -e SERVERNAME=stats.notaserver.net \
    -p 80:80 \
    -p 443:443 \
    danieldent/nginx-ssl-proxy
