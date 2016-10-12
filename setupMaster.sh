#!/bin/bash

OWN_IP=$(ip -4 -br address | grep eth1 | awk '{ split($3,a,"/"); print a[1]'})

exist=$(docker ps -a | grep "swarm manage" -m 1 | awk '{ print $1 }')
if [[ -z ${exist} ]];
then
docker run -d -p 4000:4000 swarm manage -H :4000 --advertise ${OWN_IP}:4000 consul://${OWN_IP}:8500
else
 docker start ${exist}
fi


