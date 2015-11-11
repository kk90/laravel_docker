#!/bin/bash

docker run --name laravel -d \
    --publish 8080:80 \
    --publish 2222:22 \
    --volume $(pwd)/server:/data \
    laravel_image