# Devops example Flask app dockerized


## Usage
```
make dev: builds docker image and run it publishing port 5000 on 127.0.0.1 (the build includes unit testing)
make test: execute some "curl" test to the container
make clean: stop container and removes image
```
## Configuration

You can pass the DATABASE_URL variable to the container in order to use a external (mysql) database instead local sqlite file

Example:
```bash
docker build -t devops .
docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=db mysql
docker run -d --link mysql:mysql --name devops -e DATABASE_URL="mysql://root:root@mysql/db" -p 5000:5000 devops:latest
```

