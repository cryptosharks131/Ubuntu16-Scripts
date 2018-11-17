clear

echo -e "Updating the system and installing basic dependencies."
sudo apt-get -y install build-essential libtool autotools-dev autoconf pkg-config libssl-dev apache2 >/dev/null 2>&1
sudo apt-get -y install libboost-all-dev zip git npm nodejs nodejs-legacy libminiupnpc-dev redis-server >/dev/null 2>&1
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
sudo ufw default allow outgoing >/dev/null 2>&1
sudo ufw default deny incoming >/dev/null 2>&1
sudo ufw allow ssh/tcp >/dev/null 2>&1
sudo ufw limit ssh/tcp >/dev/null 2>&1
sudo ufw allow 'Apache Full' >/dev/null 2>&1
sudo ufw logging on >/dev/null 2>&1
yes "y" | sudo ufw enable >/dev/null 2>&1
echo -e "Completed setting up firewall."


echo -e "Setting up apache server."
sudo mkdir /var/www/wbs/ >/dev/null 2>&1
  cat << EOF > /var/www/wbs/index.html
<html>
<head>
  <title> Apache Web Server! </title>
</head>
<body>
  <p> Apache web server is ready!
</body>
</html>
EOF
  cat << EOF > /etc/apache2/sites-available/wbs.conf
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin cryptosharks131@gmail.com
        DocumentRoot /var/www/wbs/
        ServerName wbs.cryptosharkspool.com

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF
cd /etc/apache2/sites-available/
sudo a2ensite wbs.conf >/dev/null 2>&1
sudo rm 000-default.conf >/dev/null 2>&1
service apache2 reload >/dev/null 2>&1
cd
echo -e "Completed setting up apache server."
echo -e "Apache server set up in directory /var/www/wbs/"
