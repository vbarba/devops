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
## Production

The `production.yml` file provides a AWS Cloudformation template that creates all the necessary resources to deploy this container in production.

This includes the following services:

* VPC
* Elastic Container Cluster
* Security Groups
* LoadBalancer
* IAM profiles
* Fargate Service
* Task and Container definition
* RDS database (for data persistance)

You can deploy it manually through the aws console or with the following commands. It takes some time to deploy.

```bash

aws cloudformation --region eu-west-1 create-stack \
                   --stack-name devops \
                   --template-body file://production.yml \
                   --capabilities CAPABILITY_IAM

aws cloudformation --region eu-west-1 wait stack-create-complete  \
                   --stack-name devops
```

After the deploy you can get the endpoint URL with the following command:

```
aws cloudformation --region eu-west-1 describe-stacks \
                      --stack-name devops
                      --query 'Stacks[0].Outputs[0].OutputValue'

 "http://devop-LoadB-XXXXXXX.eu-west-1.elb.amazonaws.com"```

```

And then run some test setting the HOST variable on the following script:

```
HOST="devop-LoadB-EVLDZUBBAWXA-704166709.eu-west-1.elb.amazonaws.com"
PORT="80"
TEST_USER='{"id":1,"username":"test1","email":"test@test.com"}'

# create user
curl -f -H "Content-Type: application/json" -X POST -d ${TEST_USER} http://${HOST}:${PORT}/user
# get user
curl -f http://${HOST}:${PORT}/user/1
# get users
curl -f http://${HOST}:${PORT}/users
# delete user
curl -f -X DELETE http://${HOST}:${PORT}/user/1
```
