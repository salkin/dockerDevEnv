#!/usr/bin/env ruby

module Script                                                                                                                                                 
PROXY_SETUP = <<-SHELL 
PROXY=$1
mkdir -p /etc/systemd/system/docker.service.d/
echo '[Service]' > /etc/systemd/system/docker.service.d/http-proxy.conf
echo "Environment=\"HTTP_PROXY=http://$PROXY\" \"HTTPS_PROXY=$PROXY\" \"NO_PROXY=localhost,127.0.0.0/8\"" >> /etc/systemd/system/docker.service.d/http-proxy.conf

systemctl daemon-reload
systemctl restart docker
SHELL

BOOTSTRAP = <<-SHELL
CLUSTER_IP=$1
OWN_IP=$2
zypper -n in docker git net-tools-deprecated
if [ -d dockerDevEnv ]; then
  cd dockerDevEnv
  git pull
  cd -
else
  git clone https://github.com/salkin/dockerDevEnv.git
fi

echo $OWN_IP
  
mkdir -p /etc/systemd/system/docker.service.d/
  
cat << EOF > /etc/sysconfig/docker
DOCKER_OPTS="-H tcp://0.0.0.0:2375 --cluster-store=consul://${CLUSTER_IP}:8500 --cluster-advertise=${OWN_IP}:2375"
EOF

systemctl enable docker
systemctl start docker
SHELL


MASTER_SETUP = <<-SHELL
dockerDevEnv/setupMaster.sh
SHELL

NODE_SETUP = <<-SHELL
CONSUL=$1
dockerDevEnv/setupNode.sh $CONSUL
SHELL

CONSUL = <<-SHELL
ADDR=$1

mkdir -p /opt/consul 
wget -nc https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip -P /opt/consul
unzip -o /opt/consul/consul_0.7.0_linux_amd64.zip -d /opt/consul && mkdir -p /etc/consul.d

cat << EOF > /etc/systemd/system/consul.service
Description=Consul agent
Before=docker.service

[Service]
ExecStart=/opt/consul/consul agent -server -bootstrap-expect=1 -data-dir=/var/consul -advertise=$ADDR -bind=0.0.0.0 -client=$ADDR
Restart=Always
RestartSec=4s

[Install]
WantedBy=multi-user.target
EOF
systemctl start consul
systemctl enable consul
SHELL
end




