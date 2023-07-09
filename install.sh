#!/bin/bash

set -e
#set -x

if [ -z "${L1_ENDPOINT_HTTP}" ]; then
  echo "Lütfen L1_ENDPOINT_HTTP değişkenini atayın."
  echo "Please export L1_ENDPOINT_HTTP"
  exit
fi

if [[ -z "${L1_ENDPOINT_WS}" ]]; then
  echo "Lütfen L1_ENDPOINT_WS değişkenini atayın."
  echo "Please export L1_ENDPOINT_WS"
  exit
fi

read -p "Do you want to enable prover? [y/n] Proverı etkinleştirmek istiyor musunuz? [y/n]: " enable_prover

if [ ${enable_prover} = "y" ]; then
  if [[ -z "${L1_PROVER_PRIVATE_KEY}" ]]; then
    echo "Lütfen L1_PROVER_PRIVATE_KEY değişkenini atayın."
    echo "Please export L1_PROVER_PRIVATE_KEY"
    exit
  fi
else
  echo "!!!Prover etkinleştirilmedi!!!"
  echo "!!!Prover is not enabled!!!"
fi

# Install docker and docker compose plugin
apt -y update
apt -y install ca-certificates curl gnupg

set +e
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt -y remove $pkg; done
rm /etc/apt/keyrings/docker.gpg
rm simple-taiko-node
set -e
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
   tee /etc/apt/sources.list.d/docker.list > /dev/null
 apt -y update
 apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install git
apt -y install git

git clone https://github.com/taikoxyz/simple-taiko-node.git
cd simple-taiko-node
cp .env.sample .env

sed -i "s,L1_ENDPOINT_HTTP=,L1_ENDPOINT_HTTP=${L1_ENDPOINT_HTTP},g" .env
sed -i "s,L1_ENDPOINT_WS=,L1_ENDPOINT_WS=${L1_ENDPOINT_WS},g" .env

if [ ${enable_prover} = "y" ]; then
  sed -i "s,ENABLE_PROVER=false,ENABLE_PROVER=true,g" .env
  sed -i "s,L1_PROVER_PRIVATE_KEY=,L1_PROVER_PRIVATE_KEY=${L1_PROVER_PRIVATE_KEY},g" .env
fi

docker compose up -d

#set +x
set +e
