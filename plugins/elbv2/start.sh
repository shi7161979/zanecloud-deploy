#!/usr/bin/env bash

BASE_DIR=$(cd `dirname $0` && pwd -P)

AWS_REGION=$(curl -fsL 169.254.169.254/latest/meta-data/region)
AWS_INSTANCE_ID=$(curl -fsL 169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)


docker run --net=host -ti --rm \
        -v ${BASE_DIR}:${BASE_DIR} \
	    -v /var/run/docker.sock:/var/run/docker.sock \
        -e DOCKER_HOST=unix:///var/run/docker.sock  \
        -e LOCAL_IP=${LOCAL_IP} \
        -e AWS_REGION=${AWS_REGION} \
	    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}  \
	    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	    -e AWS_INSTANCE_ID=${AWS_INSTANCE_ID} \
        -w ${BASE_DIR} \
        docker/compose:1.9.0 \
        up -d $*