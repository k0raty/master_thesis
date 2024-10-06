%title: Wazuh
%author: xavki


██╗    ██╗ █████╗ ███████╗██╗   ██╗██╗  ██╗
██║    ██║██╔══██╗╚══███╔╝██║   ██║██║  ██║
██║ █╗ ██║███████║  ███╔╝ ██║   ██║███████║
██║███╗██║██╔══██║ ███╔╝  ██║   ██║██╔══██║
╚███╔███╔╝██║  ██║███████╗╚██████╔╝██║  ██║
 ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                                           

-----------------------------------------------------------------------------------------------------------                                          

# WAZUH : Drop ssh brute force

<br>

* check to brute force an agent

* vagrant : 
		* activate ssh password configuration
		* restart sshd
		* check vagrant

-----------------------------------------------------------------------------------------------------------                                          

# WAZUH : Drop ssh brute force

<br>

* purpose : activate /var/ossec/active-response/bin/firewall-drop

* check that command is activated in /var/ossec/etc/ossec.conf

```
<command>
  <name>firewall-drop</name>
  <executable>firewall-drop</executable>
  <timeout_allowed>yes</timeout_allowed>
</command>
```

-----------------------------------------------------------------------------------------------------------                                          

# WAZUH : Drop ssh brute force

<br>

* activate a new rule

```
  <active-response>
    <command>firewall-drop</command>
    <location>local</location>
    <rules_id>5763</rules_id>
    <timeout>180</timeout>
  </active-response>
```

* then restart the wazuh-manager

```
systemctl restart wazuh-manager
```

-----------------------------------------------------------------------------------------------------------                                          

# WAZUH : Drop ssh brute force

<br>

* check with ping

* create a pasword file and install hydra to brute force ssh user

```
sudo apt update && sudo apt install -y hydra
sudo hydra -t 4 -l vagrant -P passwords.lst wazagent2 ssh
```

* check your ping

-----------------------------------------------------------------------------------------------------------                                          

# WAZUH : Drop ssh brute force

<br>

* check security event for the target agent
