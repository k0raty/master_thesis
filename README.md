# master_thesis
Software system monitoring network based on advanced methods


# Wazuh Environment Setup with Vagrant, Docker, and VirtualBox
The setup is based on a VAGRANT env (https://gitlab.com/xavki/vagrant-files/-/tree/master/wazuh?ref_type=heads )

```markdown
## Prerequisites

Ensure that the following are installed on your system:
- **Vagrant** (Version 2.2.x or later)
- **VirtualBox** (Or any Vagrant-supported provider)
- **Docker Engine** (Version 27.3.1, build ce12230)
- **Docker Compose** (Included in the provisioning scripts)

## Setup Steps

### 1. Clone the Repository

Clone the repository containing your Vagrant and configuration files:

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. IP Address Configuration

Before launching the environment, modify the `wazuh_config.sh` file to set the correct IP addresses for each VM:

- **Wazuh Manager IP**: Used in the `ossec.conf` file to specify where the agent should report.
- **Agent IPs**: Configured in the `ossec.conf` file to establish the agent-server connection.

In `wazuh_config.sh`:
```bash
# Example IP Address configuration
export WAZUH_SERVER_IP="192.168.56.0"
export AGENT_IP1="192.168.56.1"
export AGENT_IP2="192.168.56.2"
```

**Note:** Ensure that these IPs are reflected in the corresponding `ossec.conf` files located in the Wazuh manager and agents:
- Wazuh Manager config: `/var/ossec/etc/ossec.conf`
- Wazuh Agent config: `/var/ossec/etc/ossec.conf` (for each agent)

Modify the `<server>` tags in `ossec.conf`:
```xml
<server>
  <address>192.168.56.0</address> <!-- Wazuh Manager IP -->
</server>
```

### 3. Vagrant Configuration

The `Vagrantfile` defines the network and system resources for each virtual machine. It will configure the Wazuh manager and two agents.

Modify the `Vagrantfile` if needed, or proceed with the default settings. The default nodes are:

- **Wazuh Manager**: IP `192.168.56.0`, 4 CPUs, 6000MB RAM
- **Agent 1**: IP `192.168.56.1`, 2 CPUs, 2048MB RAM
- **Agent 2**: IP `192.168.56.2`, 2 CPUs, 2048MB RAM

If using the plugin vagrant-faster , CPUs and memory would be allocated accordingly to the machine specification : may be unappropriate while running vm on vscode
### 4. Launch the Environment

To create and launch the environment, run the following:

```bash
vagrant up
```

This command will:
- Create virtual machines for the Wazuh manager and agents.
- Provision each machine by installing necessary dependencies (Docker, Wazuh) and configuring them via the `install_wazuh_server.sh` and `install_wazuh_agent.sh` scripts.

### 5. Access the Machines

After launching, you can SSH into any of the machines:

```bash
vagrant ssh wazidx1   # Wazuh Manager
vagrant ssh wazagent1 # Wazuh Agent 1
vagrant ssh wazagent2 # Wazuh Agent 2
```

### 6. Stopping and Destroying the Environment

To stop all running virtual machines:

```bash
vagrant halt
```

To destroy all virtual machines and clean up:

```bash
vagrant destroy
```

### 7. Modifying `ossec.conf` Files

After the VMs are up, SSH into each machine and edit the `ossec.conf` file if necessary.

#### Wazuh Manager (`wazidx1`)
```bash
sudo nano /var/ossec/etc/ossec.conf
```
Ensure the IP in the `<agent>` section matches the agents' IPs.

#### Wazuh Agent (`wazagent1`, `wazagent2`)
```bash
sudo nano /var/ossec/etc/ossec.conf
```
Ensure the IP in the `<server>` section matches the Wazuh Manager's IP.

### 8. Managing Wazuh Services

To start or stop the Wazuh services:

#### On Wazuh Manager
```bash
sudo systemctl start wazuh-manager
sudo systemctl stop wazuh-manager
```

#### On Wazuh Agents
```bash
sudo systemctl start wazuh-agent
sudo systemctl stop wazuh-agent
```
#### 
### Notes

- Make sure your IP addresses are consistent across all configuration files (`ossec.conf`).
- Vagrant provisions the environment using scripts, which automate the installation and setup process.
- To get credentials for login :  
```bash
sudo tar -axf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt -O | grep -P "\'admin\'" -A 1
```

### Access VM on VScode

## Prerequisites

    Public/Private SSH Key Pair:
        Before proceeding, ensure that you have an SSH key pair (id_ed25519 or id_rsa) generated on your local machine. You can generate one using the command below if you don't already have it:

        bash

    ssh-keygen -t ed25519 -C "your_email@example.com"

    The private key will be stored in ~/.ssh/id_ed25519 (or id_rsa), and the public key will be in ~/.ssh/id_ed25519.pub.

## Public Key on VM:

    To access your VMs via SSH, your public key must be added to the VM. This is typically done by placing the public key (~/.ssh/id_ed25519.pub) in the ~/.ssh/authorized_keys file of the root user on the VM.
    Ensure that password authentication is disabled, and only key-based access is used for added security.

The `generate_ssh_config.sh` script is designed to **automate the process** of modifying the `~/.ssh/config` file on your local machine, simplifying SSH access to your VMs. Instead of manually entering configuration details for each machine, the script automatically generates the necessary SSH configurations for specific VMs and updates the `~/.ssh/config` file accordingly.

This means that after running the script, you'll have predefined shortcuts in your SSH configuration file for each of your VMs. These shortcuts make it easy to connect to each VM using a simple alias, without having to specify details like hostname, port, user, or SSH key manually.

Here's how the automation works:

- The script creates SSH entries for each VM (e.g., `wazidx1`, `wazagent1`, and `wazagent2`), defining essential parameters such as:
  - **Host**: The alias for the VM (e.g., `wazidx1`).
  - **HostName**: The VM's IP address (e.g., `127.0.0.1`).
  - **Port**: The port to connect via SSH (e.g., `2222`).
  - **User**: The user account for SSH access (e.g., `root`).
  - **IdentityFile**: The path to your private SSH key (e.g., `~/.ssh/id_ed25519`).
  
- The script automatically modifies the `~/.ssh/config` file to include these details, replacing existing configurations for these hosts if necessary.

This process saves time and reduces the chances of error when setting up SSH access to multiple VMs. After running the script, you can connect to any configured VM using a simple command like:
```bash
ssh wazidx1
```

Additionally, the script ensures that SSH access is set up securely by enforcing key-based authentication, disabling password authentication, and configuring SSH settings for automation.

By using this script, you can streamline the configuration process, making it easy to manage multiple VMs without manually editing the SSH config file.

## Using SSH in VSCode

You can also access these VMs via Visual Studio Code using the Remote - SSH extension, which allows you to open a remote machine or VM in VSCode over SSH.

    Install the Remote - SSH extension:
        Go to the Extensions view in VSCode (Ctrl+Shift+X) and search for "Remote - SSH." Install it.

    Connect to a VM:
        Open the Command Palette (Ctrl+Shift+P), type "Remote-SSH: Connect to Host...", and select it.
        Type the alias of your VM (e.g., wazidx1) from the SSH config file, and you'll be connected to the VM.
        Once connected, you'll be able to use VSCode just as you would on your local machine, with access to the filesystem, terminal, and more.

    Root Access:
        Since the User in your ~/.ssh/config is set to root, you'll be connected as the root user, giving you full administrative access to the VM.

This setup allows you to use VSCode for development directly on your remote VMs without needing to open separate terminal windows, making it convenient to manage multiple machines.
## Contact

For any issues or further assistance, please contact [antony.davi@centrale.centralelille.fr](mailto:antony.davi@centrale.centralelille.fr).
```
