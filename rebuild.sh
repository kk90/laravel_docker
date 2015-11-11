#!/bin/bash
docker stop laravel
docker rm laravel
docker rmi laravel_image
./build.sh
./up.sh
