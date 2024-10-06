%title: Wazuh
%author: xavki


██╗    ██╗ █████╗ ███████╗██╗   ██╗██╗  ██╗
██║    ██║██╔══██╗╚══███╔╝██║   ██║██║  ██║
██║ █╗ ██║███████║  ███╔╝ ██║   ██║███████║
██║███╗██║██╔══██║ ███╔╝  ██║   ██║██╔══██║
╚███╔███╔╝██║  ██║███████╗╚██████╔╝██║  ██║
 ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                                           

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : IDS - Suricata

<br>

Doc : https://documentation.wazuh.com/current/proof-of-concept-guide/integrate-network-ids-suricata.html


Suricata : 

		* deep packet inspection

		* IDS (Intrusion Detection System)

		* GUI = Sirius

		* ANSSI evaluation : https://cyber.gouv.fr/produits-certifies/suricata-version-608

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : IDS - Suricata


<br>

Add suricata repo and install it

```
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt-get update
sudo apt-get install suricata -y
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : IDS - Suricata

<br>

* add some rules

```
cd /tmp/ && curl -LO https://rules.emergingthreats.net/open/suricata-6.0.8/emerging.rules.tar.gz
mkdir -p /etc/suricata/rules/
sudo tar -xvzf emerging.rules.tar.gz && sudo mv rules/*.rules /etc/suricata/rules/
sudo chmod 640 /etc/suricata/rules/*.rules
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : IDS - Suricata

<br>

* edit suricata settings /etc/suricata/suricata.yaml

```
HOME_NET: "<UBUNTU_IP>"
EXTERNAL_NET: "any"

rule-files:
- "*.rules"
- "/etc/suricata/rules/*.rules"

# Global stats configuration
stats:
enabled: yes

# Linux high speed capture support
af-packet:
  - interface: enp0s8
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : IDS - Suricata

<br>

* restart suricata

```
sudo systemctl restart suricata
```

* add local file in wazuh-agent /var/ossec/etc/ossec.conf

```
<ossec_config>
  <localfile>
    <log_format>json</log_format>
    <location>/var/log/suricata/eve.json</location>
  </localfile>
</ossec_config>
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : IDS - Suricata

<br>

* test with ping

```
ping -c 100 192.168.12.182
```

* with nmap script

```
./snort-scan.sh 192.168.12.18
```

Note : rule.groups:suricata
