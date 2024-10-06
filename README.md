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

### Notes

- Make sure your IP addresses are consistent across all configuration files (`ossec.conf`).
- Vagrant provisions the environment using scripts, which automate the installation and setup process.
- To get credentials for login :  
```bash
sudo tar -axf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt -O | grep -P "\'admin\'" -A 1
```bash

## Contact

For any issues or further assistance, please contact [antony.davi@centrale.centralelille.fr](mailto:antony.davi@centrale.centralelille.fr).
```
