#!/usr/bin/bash

# Source the Wazuh configuration file to get IP addresses and repository URL
source wazuh_config.sh  # Update this path to the actual location of your config file

# Add GPG key and repository using the repository URL from the config
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] $WAZUH_AGENT_REPO_URL stable main" | tee /etc/apt/sources.list.d/wazuh.list

# Update package list
apt-get update

# Install the Wazuh agent version that matches the manager
WAZUH_MANAGER="$WAZUH_SERVER_IP" apt-get install wazuh-agent

# Enable and start the Wazuh agent service
systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent



