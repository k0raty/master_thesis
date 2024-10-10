#!/bin/bash
# Configuration file to have root access of the VM on VScode 
# Add each server and agent analogically.
# Define the SSH configuration file path
# TODO dynamic variable to precise a specific folder for keys
SSH_CONFIG_FILE="$HOME/.ssh/config"

# Function to update or add host configuration
update_or_add_host() {
  local host_name=$1
  local config_block=$2

  # Check if the host already exists in the config file
  if grep -q "Host $host_name" "$SSH_CONFIG_FILE"; then
    # Replace the existing host configuration
    sed -i "/Host $host_name/,+10d" "$SSH_CONFIG_FILE"
    echo "Updated $host_name configuration."
  else
    echo "Added new $host_name configuration."
  fi

  # Append the new configuration to the file
  echo "$config_block" >> "$SSH_CONFIG_FILE"
}

# Create the configuration blocks for each host
config_wazidx1=$(cat <<EOF
Host wazidx1
  HostName 127.0.0.1
  User root
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  LogLevel FATAL
  PubkeyAcceptedKeyTypes +ssh-rsa
  HostKeyAlgorithms +ssh-rsa
EOF
)

config_wazagent1=$(cat <<EOF
Host wazagent1
  HostName 127.0.0.1
  User root
  Port 2200
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  LogLevel FATAL
  PubkeyAcceptedKeyTypes +ssh-rsa
  HostKeyAlgorithms +ssh-rsa
EOF
)

config_wazagent2=$(cat <<EOF
Host wazagent2
  HostName 127.0.0.1
  User root
  Port 2201
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  LogLevel FATAL
  PubkeyAcceptedKeyTypes +ssh-rsa
  HostKeyAlgorithms +ssh-rsa
EOF
)

# Call the function for each host
update_or_add_host "wazidx1" "$config_wazidx1"
update_or_add_host "wazagent1" "$config_wazagent1"
update_or_add_host "wazagent2" "$config_wazagent2"

# Set the correct permissions for the SSH configuration file
chmod 600 "$SSH_CONFIG_FILE"

echo "SSH configuration file updated at $SSH_CONFIG_FILE"
