#! /usr/bin/bash

docker run --name wasix-test-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=passwd -d mysql:9
docker run --name wasix-test-pgsql -p 5432:5432 -e POSTGRES_PASSWORD=passwd -d postgres:16