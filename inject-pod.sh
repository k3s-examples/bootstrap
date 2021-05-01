#!/bin/bash

read -p "Name of docker image you want to use (Default: ubuntu:latest)> " IMAGE_NAME
[ -z $ IMAGE_NAME ] && IMAGE_NAME=ubuntu:latest

kubectl run quick-view -i -t --rm --image ${IMAGE_NAME}