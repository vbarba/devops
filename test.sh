#!/bin/bash -e

TEST_USER='{"id":1,"username":"test1","email":"test@test.com"}'
HOST="127.0.0.1"
PORT="5000"
#HOST="devop-LoadB-1907IATCPWFXO-2120024973.eu-west-1.elb.amazonaws.com"
#PORT="80"

# create user
curl -f -s -o /dev/null -H "Content-Type: application/json" -X POST -d ${TEST_USER} http://${HOST}:${PORT}/user && echo "TEST CREATE USER OK" || echo "ERROR ON CREATE USER"

# get user
curl -f -s -o /dev/null http://${HOST}:${PORT}/user/1 && echo "TEST GET USER OK" || echo "ERROR ON GET USER"

# get users
curl -f -s -o /dev/null http://${HOST}:${PORT}/users && echo "TEST GET USERS OK"|| echo "ERROR ON GET USERS"

# delete user
curl -f -s -o /dev/null -X DELETE http://${HOST}:${PORT}/user/1 && echo "TEST DELETE USER OK" || echo "ERROR ON DELETE USER"
