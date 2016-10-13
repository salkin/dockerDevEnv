#!/bin/bash
install_compose() {
   curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
   chmod +x /usr/bin/docker-compose
}

OWN_IP=$(ip -4 -br address | grep eth1 | awk '{ split($3,a,"/"); print a[1]'})

exist=$(docker ps -a | grep "swarm manage" -m 1 | awk '{ print $1 }')
if [[ -z ${exist} ]];
then
docker run -d -p 4000:4000 swarm manage -H :4000 --advertise ${OWN_IP}:4000 consul://${OWN_IP}:8500
else
 docker start ${exist}
fi

docker-compose -v >/dev/null 2>&1 || { echo "Docker compose required"; install_compose;  }

git clone https://github.com/salkin/weightServer.git
cd weightServer

export DOCKER_HOST=:4000
docker-compose -f compose.yml up -d





