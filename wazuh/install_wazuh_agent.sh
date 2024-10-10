#!/usr/bin/bash
#TOHAVE Dynamic IP SERVER Retrieving -> waizdx1 2 or 3 ?...
source wazuh_config.sh  # Update this path to the actual location of your config file


# Ensure that SSH agent is configured to accept public key authentication
sudo sed -i '/^#\?PubkeyAuthentication /c\PubkeyAuthentication yes' /etc/ssh/sshd_config
sudo sed -i '/^#\?AuthorizedKeysFile /c\AuthorizedKeysFile .ssh/authorized_keys' /etc/ssh/sshd_config

# Capture the Wazuh agent's IP address | Private network IP address!
WAZUH_AGENT_IP=$(hostname -I | awk '{print $2}')
echo "Node: $(hostname) - IP: $WAZUH_AGENT_IP" >> $CREDENTIALS_FILE

# Retrieve the Wazuh server IP from the credentials file
WAZUH_SERVER_IP=$(grep "Node: wazidx1" $CREDENTIALS_FILE | awk '{print $5}')
echo "Wazuh Server IP: $WAZUH_SERVER_IP"

# Add echo statement for node hostname assignment
echo "Node hostname '$(hostname)' assigned to the following server: 'wazidx1'"

# Add GPG key and repository using the repository URL from the config
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] $WAZUH_AGENT_REPO_URL stable main" | tee /etc/apt/sources.list.d/wazuh.list

# Update package list
apt-get update

# Install the Wazuh agent version that matches the manager
WAZUH_MANAGER="$WAZUH_SERVER_IP" apt-get install -y wazuh-agent

# Enable and start the Wazuh agent service
systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent
