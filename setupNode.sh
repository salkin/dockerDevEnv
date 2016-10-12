#!/bin/bash

CONSUL_NODE=$1
OWN_HOST=$(ip -4 -br address | grep eth1 | awk '{ split({$3,a,"/"); print a[1]}')

exist=$(docker ps -a | grep "swarm join" -m 1 | awk '{ print ( }')
if [[ -z ${exist}  ]];
then
docker run -d swarm join --advertise=${OWN_HOST}:2375 consul://${CONSUL_NODE}:8500
else
docker start ${exist}
fi
