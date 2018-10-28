apt update
apt upgrade

apt-get install build-essential libtool autotools-dev autoconf pkg-config libssl-dev apache2
apt-get install libboost-all-dev git npm nodejs nodejs-legacy libminiupnpc-dev redis-server
yes "" | add-apt-repository ppa:bitcoin/bitcoin
apt-get update
apt-get install libdb4.8-dev libdb4.8++-dev
apt-get -y install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
