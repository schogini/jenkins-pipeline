#!/bin/sh


qq=$(docker service ls|grep -c tmp1-svc)

#// --update-delay

if [ $qq -gt 0 ]; then
	echo "Doing a Rolling Update.. $1 "
	docker service update --env-add WEB=$2 --image $1 tmp1-svc2
else
	echo "Deploying Application.. $1"
	docker service create --name tmp1-svc2 --replicas 2 --publish 8082:8080 --env WEB=$2 $1
fi