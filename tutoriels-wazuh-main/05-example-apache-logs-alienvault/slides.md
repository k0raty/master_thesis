%title: Wazuh
%author: xavki


██╗    ██╗ █████╗ ███████╗██╗   ██╗██╗  ██╗
██║    ██║██╔══██╗╚══███╔╝██║   ██║██║  ██║
██║ █╗ ██║███████║  ███╔╝ ██║   ██║███████║
██║███╗██║██╔══██║ ███╔╝  ██║   ██║██╔══██║
╚███╔███╔╝██║  ██║███████╗╚██████╔╝██║  ██║
 ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                                           

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Server Apache && AlienVault database

<br>

* install apache on target server

```
sudo apt install apache2
sudo systemctl start apache2
curl 127.0.0.1
sudo netstat -ntaup
```


-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Server Apache && AlienVault database

<br>

* edit wazuh-agent configuration to collect apache logs

/var/ossec/etc/ossec.conf

```
<localfile> 
   <log_format>syslog</log_format> 
   <location>/var/log/apache2/access.log</location> 
</localfile>
```

```
sudo systemctl restart wazuh-agent
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Server Apache && AlienVault database

<br>

* add alienvault ip list on wazuh server

```
sudo wget https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/alienvault_reputation.ipset -O /var/ossec/etc/lists/alienvault_reputation.ipset
```

* add another ip

```
sudo echo "<hacker_ip>" >> /var/ossec/etc/lists/alienvault_reputation.ipset
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Server Apache && AlienVault database

<br>

* use the wazuh script to convert the list in cbd format

```
sudo wget https://wazuh.com/resources/iplist-to-cdblist.py -O /tmp/iplist-to-cdblist.py
sudo /var/ossec/framework/python/bin/python3 iplist-to-cdblist.py /var/ossec/etc/lists/alienvault_reputation.ipset /var/ossec/etc/lists/blacklist-alienvault
sudo chown wazuh:wazuh /var/ossec/etc/lists/blacklist-alienvault
sudo rm -rf /var/ossec/etc/lists/alienvault_reputation.ipset 
sudo rm -rf iplist-to-cdblist.py
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Server Apache && AlienVault database

<br>

* test logs parsing and rules

```
echo '192.168.12.182 - - [08/Feb/2024:20:11:22 +0000] "GET / HTTP/1.1" 200 10926 "-" "curl/7.81.0"' | sudo /var/ossec/bin/wazuh-logtest
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Server Apache && AlienVault database

<br>

* change rule level for webserver logs with /var/ossec/ruleset/rules/0245-web_rules.xml

```
  <rule id="31108" level="3">
    <if_sid>31100</if_sid>
    <id>^2|^3</id>
    <compiled_rule>is_simple_http_request</compiled_rule>
    <description>Ignored URLs (simple queries).</description>
  </rule>
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Server Apache && AlienVault database

<br>

* change to store logs temporarly in archive  with /var/ossec/etc/ossec.conf

```
<logall>yes</logall>
```

* check with archive logs

```
tail -f /var/ossec/logs/archives/archives.log  | grep apache
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Server Apache && AlienVault database

<br>

* add a new specific rule for alienvault ip list

/var/ossec/etc/rules/local_rules.xml

```
<group name="attack,"> 
  <rule id="100100" level="10"> 
     <if_group>web|attack|attacks</if_group> 
     <list field="srcip" lookup="address_match_key">etc/lists/blacklist-alienvault</list> 
     <description>IP found in AlienVault database</description> 
  </rule> 
</group>
```

```
sudo systemctl restart wazuh-manager
```


-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Server Apache && AlienVault database

<br>

* edit /var/ossec/etc/ossec.conf to add the alienvault list

```
<ossec_config> 
   <ruleset> 
    ...
     <list>etc/lists/blacklist-alienvault</list>
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Server Apache && AlienVault database

<br>

* add the active response in /var/ossec/etc/ossec.conf

```
<ossec_config> 
  <active-response> 
    <command>firewall-drop</command> 
    <location>local</location> 
    <rules_id>100100</rules_id> 
    <timeout>60</timeout> 
  </active-response> 
</ossec_config>
```

```
sudo systemctl restart wazuh-manager
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Server Apache && AlienVault database

<br>

* check with curl

* go into security events and check the rule 100100 and host blocked
