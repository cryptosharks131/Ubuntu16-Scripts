PASSWORD='enter your password'
USERNAME='enter your username'
SSHPUB='enter your RSA Pub key here, the full text in one line'

clear

echo -e "Updating the system and installing basic dependencies."
sudo apt-get -y update >/dev/null 2>&1
sudo apt-get -y install fail2ban >/dev/null 2>&1
sudo systemctl enable fail2ban >/dev/null 2>&1
sudo systemctl start fail2ban >/dev/null 2>&1
echo -e "Completed updating the system and installing basic dependencies."

echo -e "Adding 8GB of swap space."
sudo fallocate -l 8G /swapfile >/dev/null 2>&1
sudo chmod 600 /swapfile >/dev/null 2>&1
sudo mkswap /swapfile >/dev/null 2>&1
sudo swapon /swapfile >/dev/null 2>&1
  cat << EOF >> /etc/sysctl.conf
vm.swappiness=10
EOF
  cat << EOF >> /etc/fstab
/swapfile none swap sw 0 0
EOF
echo -e "Completed adding 8GB of swap space."

echo -e "Setting up firewall."
sudo ufw default allow outgoing >/dev/null 2>&1
sudo ufw default deny incoming >/dev/null 2>&1
sudo ufw limit ssh/tcp >/dev/null 2>&1
sudo ufw limit 443 >/dev/null 2>&1
sudo ufw logging on >/dev/null 2>&1
yes "y" | sudo ufw enable >/dev/null 2>&1
echo -e "Completed setting up firewall."

echo -e "Applying security settings."
useradd -m -p ${PASSWORD} -s /bin/bash ${USERNAME}
usermod -a -G sudo ${USERNAME}
usermod -a -G ssh ${USERNAME}
sleep 1
echo -e "${PASSWORD}\n${PASSWORD}" | passwd ${USERNAME}
mkdir /home/${USERNAME}/.ssh/
chown ${USERNAME} /home/${USERNAME}/.ssh/
chgrp ${USERNAME} /home/${USERNAME}/.ssh/
echo  ${SSHPUB} > /home/${USERNAME}/.ssh/authorized_keys
chown ${USERNAME} /home/${USERNAME}/.ssh/authorized_keys
chgrp ${USERNAME} /home/${USERNAME}/.ssh/authorized_keys
sed -i -e 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i -e 's/#AuthorizedKeysFile/AuthorizedKeysFile/g' /etc/ssh/sshd_config
sed -i -e 's/X11Forwarding yes/X11Forwarding no/g' /etc/ssh/sshd_config
sed -i -e 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
systemctl restart sshd
echo -e "Completed applying security settings."

echo -e "System hardening is now complete."
