sudo passwd pi
sudo mkdir -p nextcloud_compose
sudo chown -R pi:pi nextcloud_compose
mkdir -p nextcloud_compose/ncdata
mkdir -p nextcloud_compose/ncconfig
mkdir -p nextcloud_compose/dbconfig
cd nextcloud_compose
id

# change mypassword

cat << EOF | tee docker-compose.yml
version: '3'
services:
    db_host:
        image: linuxserver/mariadb
        container_name: nextcloud-mariadb
        networks:
            - nextcloud_network
        volumes:
            - ./dbconfig:/config
            - /etc/localtime:/etc/localtime:ro
        ports:
            - 3306:3306
        environment:
            - PUID=1000
            - PGID=1000
            - MYSQL_ROOT_PASSWORD=mypassword
            - MYSQL_PASSWORD=mypassword
            - MYSQL_DATABASE=nextcloud
            - MYSQL_USER=nextcloud
        restart: unless-stopped
    nextcloud_app:
        image: linuxserver/nextcloud
        container_name: nextcloud-app
        ports:
            - 80:80
            - 443:443
        environment:
            - PUID=1000
            - PGID=1000
            - MYSQL_HOST=db_host
        links:
            - db_host
        networks:
            - nextcloud_network
        volumes:
            - ./ncdata:/data
            - ./ncconfig:/config
        restart: unless-stopped
networks:
    nextcloud_network:
EOF


cat << EOF | tee deleteme.sh && chmod +x deleteme.sh && ./deleteme.sh
#https://devdojo.com/bobbyiliev/how-to-install-docker-and-docker-compose-on-raspberry-pi
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ${USER}
sudo gpasswd -a $USER docker
sudo su - ${USER}
docker version
sudo apt-get install -y libffi-dev libssl-dev
sudo apt install -y python3-dev
sudo apt-get install -y python3 python3-pip
sudo pip3 install docker-compose
EOF

docker-compose pull
docker-compose up -d
