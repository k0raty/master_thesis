# wazuh_config.sh

# Configuration Variables #

# WAZUH URL #
#VERSION BTW MANAGER AND AGENT HAVE TO MATCH#

# Define the Wazuh version
export WAZUH_VERSION="4.9.0-1"

# Repository URL for the Wazuh agent
export WAZUH_GPG_KEY="https://packages.wazuh.com/$WAZUH_VERSION/apt/doc/wazuh-key.gpg"
export WAZUH_AGENT_REPO_URL="https://packages.wazuh.com/4.x/apt/"

# Wazuh manager installation script URL
export WAZUH_MANAGER_INSTALL_SCRIPT_URL="https://packages.wazuh.com/$WAZUH_VERSION/wazuh-install.sh"

export WAZUH_MANAGER_CONFIG_SCRIPT_URL="https://packages.wazuh.com/$WAZUH_VERSION/config.yml"

# IP Addresses #

# Export Manager IPss
export WAZUH_SERVER_IP="192.168.56.0"
export WAZUH_INDEXER_IP="192.168.56.0"  # Removed space around the '='
export WAZUH_DASHBOARD_IP="192.168.56.0"  # Removed space around the '='

# PORTS #
#export AGENT_PORT="1514"


