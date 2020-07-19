# groupadd adduser
sudo addgroup --system docker
# sudo useradd $USER docker
sudo gpasswd -a ${USER} docker
sudo groupadd docker && sudo gpasswd -a ${USER} docker && sudo systemctl restart docker
newgrp docker
sudo snap disable docker
sudo snap enable docker

# admin:///var/snap/docker/current
docker run hello-world

echo "version: '2'
services:
  hello_world:
    image: ubuntu
    command: [/bin/echo, 'Hello world']
" > docker-compose.yml

echo "COMPOSE_PROJECT_NAME=project_name" > .env

docker-compose up

docker-compose ps

docker system prune
