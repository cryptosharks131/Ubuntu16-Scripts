clear

echo -e "Updating the system and installing basic dependencies."
sudo apt -y update >/dev/null 2>&1
sudo apt -y upgrade >/dev/null 2>&1
sudo apt-get -y install build-essential libtool autotools-dev autoconf pkg-config libssl-dev apache2 >/dev/null 2>&1
sudo apt-get -y install libboost-all-dev git npm nodejs nodejs-legacy libminiupnpc-dev redis-server >/dev/null 2>&1
sudo add-apt-repository -y ppa:bitcoin/bitcoin >/dev/null 2>&1
sudo apt-get -y update >/dev/null 2>&1
sudo apt-get -y install libdb4.8-dev libdb4.8++-dev >/dev/null 2>&1
sudo apt-get -y install fail2ban >/dev/null 2>&1
sudo systemctl enable fail2ban >/dev/null 2>&1
sudo systemctl start fail2ban >/dev/null 2>&1
echo -e "Completed updating the system and installing basic dependencies."


echo -e "Adding 4GB of swap space."
sudo fallocate -l 4G /swapfile >/dev/null 2>&1
sudo chmod 600 /swapfile >/dev/null 2>&1
sudo mkswap /swapfile >/dev/null 2>&1
sudo swapon /swapfile >/dev/null 2>&1
  cat << EOF >> /etc/sysctl.conf
vm.swappiness=10
EOF
  cat << EOF >> /etc/fstab
/swapfile none swap sw 0 0
EOF
echo -e "Completed adding 4GB of swap space."


echo -e "Setting up firewall."
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow 'Apache Full'
sudo ufw logging on
yes "y" | sudo ufw enable
echo -e "Completed setting up firewall."
