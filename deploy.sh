#!/bin/sh


qq=$(docker service ls|grep -c tmp1-svc2)

#// --update-delay

if [ $qq -gt 0 ]; then
	echo "Doing a Rolling Update.. $1 "
	echo "docker service update --env-add WEB=$2 --env-add CUSTOM_STRING=$1 --env-add BUILD_TAG=$2 --image $1 tmp1-svc2"
	docker service update --env-add WEB=$2 --env-add CUSTOM_STRING=$1 --env-add BUILD_TAG=$2 --image $1 tmp1-svc2
else
	echo "Deploying Application.. $1"
	echo "docker service create --name tmp1-svc2 --replicas 2 --publish 8082:8080 --env WEB=$2 $1 --env CUSTOM_STRING=$1 --env BUILD_TAG=$2"
	docker service create --name tmp1-svc2 --replicas 2 --publish 8082:8080 --env WEB=$2 $1 --env CUSTOM_STRING=$1 --env BUILD_TAG=$2
fi
