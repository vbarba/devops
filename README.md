# Devops example Flask app dockerized

This apps provides an example about how to use a python Flask framework to build a API.

It provides the following endpoints:

* GET /users to get all users
* GET /user/<id> to get a user
* POST /user to create a new user 
* DELETE /user/<id> to delete a user
  
Example:

```bash

TEST_USER='{"id":1,"username":"test1","email":"test@test.com"}'

# create user
curl -f -H "Content-Type: application/json" -X POST -d ${TEST_USER} http://127.0.0.1:5000/user

{"id": 1, "username": "test1", "email": "test@test.com"}

# get user
curl -f http://127.0.0.1:5000/user/1 

{"id": 1, "username": "test1", "email": "test@test.com"}

# get users
curl -f  http://127.0.0.1:5000/users 

[{"id": 1, "username": "test1", "email": "test@test.com"}]

# delete user
curl -f -s -o /dev/null -X DELETE http://127.0.0.1:5000/user/1 

{"id": 1, "username": "test1", "email": "test@test.com"}
```

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

