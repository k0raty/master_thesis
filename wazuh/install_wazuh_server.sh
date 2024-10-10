#!/usr/bin/bash
source wazuh_config.sh

# Capture the Wazuh server's IP address
WAZUH_SERVER_IP=$(hostname -I | awk '{print $1}')
echo "Node: $(hostname) - IP: $WAZUH_SERVER_IP" >> $CREDENTIALS_FILE

# WAZUH_INDEXER_IP, WAZUH_DASHBOARD_IP, and any other IPs can similarly be extracted from credentials.txt if needed.
WAZUH_INDEXER_IP=$WAZUH_SERVER_IP
WAZUH_DASHBOARD_IP=$WAZUH_SERVER_IP

# Download the installation script and config file
curl -sO $WAZUH_MANAGER_INSTALL_SCRIPT_URL
curl -sO $WAZUH_MANAGER_CONFIG_SCRIPT_URL

# Ensure that SSH server is configured to accept public key authentication
sudo sed -i '/^#\?PubkeyAuthentication /c\PubkeyAuthentication yes' /etc/ssh/sshd_config
sudo sed -i '/^#\?AuthorizedKeysFile /c\AuthorizedKeysFile .ssh/authorized_keys' /etc/ssh/sshd_config

# Restart the SSH service to apply changes
sudo systemctl restart sshd

# Create a new config.yml file with dynamic IP addresses using echo
echo 'nodes:
  # Wazuh indexer nodes
  indexer:
    - name: wazidx1
      ip: "'"$WAZUH_INDEXER_IP"'"

  server:
    - name: wazidx1
      ip: "'"$WAZUH_SERVER_IP"'"

  # Wazuh dashboard nodes
  dashboard:
    - name: wazidx1
      ip: "'"$WAZUH_DASHBOARD_IP"'"
' > config.yml

# Run the Wazuh installation script to generate config files
bash wazuh-install.sh --generate-config-files

# Install the specified version of Wazuh
bash wazuh-install.sh --wazuh-indexer wazidx1

# Start the Wazuh cluster
bash wazuh-install.sh --start-cluster

# Extract the Wazuh admin passwords and save them
tar -axf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt -O | grep -P "\'admin\'" -A 1 >> /vagrant/credentials.txt

# Set the Wazuh server
bash wazuh-install.sh --wazuh-server wazidx1

# Set the Wazuh dashboard
bash wazuh-install.sh --wazuh-dashboard wazidx1

# Restart the Wazuh dashboard service
sudo systemctl restart wazuh-dashboard
