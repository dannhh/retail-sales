#!/bin/bash

# Run using the below command
# bash docker_conda.sh

echo "Downloading anaconda..."
wget https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh

echo "Running anaconda script..."
bash Anaconda3-2023.03-Linux-x86_64.sh -b -p ~/anaconda

echo "Removing anaconda script..."
rm Anaconda3-2023.03-Linux-x86_64.sh

#activate conda
eval "$($HOME/anaconda/bin/conda shell.bash hook)"

echo "Running conda init..."
conda init

# Using -y flag to auto-approve
echo "Running conda update..."
conda update -y conda

echo "Installed conda version..."
conda --version

echo "Running sudo apt-get update..."
sudo apt-get update

echo "Installing Docker..."
sudo apt-get -y install docker.io

echo "Docker without sudo setup..."
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo service docker restart

echo "Installing docker-compose..."
cd 
mkdir -p bin
cd bin
wget https://github.com/docker/compose/releases/download/v2.17.3/docker-compose-linux-x86_64 -O docker-compose
sudo chmod +x docker-compose
sudo chmod 666 /var/run/docker.sock

echo "Setup .bashrc..."
echo '' >> ~/.bashrc
echo 'export PATH=${HOME}/bin:${PATH}' >> ~/.bashrc

cd
sudo chmod +x bin/docker-compose
echo "docker-compose version..."
docker-compose --version

mkdir -p ~/.google/credentials