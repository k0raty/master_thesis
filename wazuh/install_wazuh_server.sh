#!/usr/bin/bash

# Source the Wazuh configuration file to get the IP addresses
source wazuh_config.sh  # Update this path to the actual location of your config file

# Assuming your wazuh_config.sh file has the following variables defined:
# WAZUH_INDEXER_IP="192.168.56.0"
# WAZUH_SERVER_IP="192.168.56.0"
# WAZUH_DASHBOARD_IP="192.168.56.0"

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

echo $WAZUH_INDEXER_IP

# Run the Wazuh installation script to generate config files
bash wazuh-install.sh --generate-config-files

# Install the specified version of Wazuh
curl -sO $WAZUH_MANAGER_INSTALL_SCRIPT_URL
bash wazuh-install.sh --wazuh-indexer wazidx1

# Start the Wazuh cluster
bash wazuh-install.sh --start-cluster

# Extract the Wazuh admin passwords
tar -axf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt -O | grep -P "\'admin\'" -A 1

# Set the Wazuh server
bash wazuh-install.sh --wazuh-server wazidx1

# Set the Wazuh dashboard
bash wazuh-install.sh --wazuh-dashboard wazidx1

# Restart the Wazuh dashboard service
sudo systemctl restart wazuh-dashboard
