#! /usr/bin/bash

stop_and_remove() {
    docker stop $1
    docker rm $1
}

stop_and_remove wasix-test-mysql
stop_and_remove wasix-test-pgsql