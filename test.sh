#!/bin/bash -e

TEST_USER='{"id":1,"username":"test1","email":"test@test.com"}'

# create user
curl -f -s -o /dev/null -H "Content-Type: application/json" -X POST -d ${TEST_USER} http://127.0.0.1:5000/user && echo "TEST CREATE USER OK" || echo "ERROR ON CREATE USER"

# get user
curl -f -s -o /dev/null http://127.0.0.1:5000/user/1 && echo "TEST GET USER OK" || echo "ERROR ON GET USER"

# get users
curl -f -s -o /dev/null http://127.0.0.1:5000/users && echo "TEST GET USERS OK"|| echo "ERROR ON GET USERS"

# delete user
curl -f -s -o /dev/null -X DELETE http://127.0.0.1:5000/user/1 && echo "TEST DELETE USER OK" || echo "ERROR ON DELETE USER"
