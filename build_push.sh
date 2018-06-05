#!/bin/bash
#
# Simple script that builds this image and pushes it to dockerhub, assuming
# the account already has logged into dockerhub
#

BRANCH=`git rev-parse --abbrev-ref HEAD`
TAG=`if [ "$BRANCH" == "master" ]; then echo "latest"; else echo $BRANCH ; fi`
IMAGE_NAME=kbase/logstash:$TAG
docker build . -t $IMAGE_NAME

docker push $IMAGE_NAME