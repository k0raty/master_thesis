%title: Wazuh
%author: xavki


██╗    ██╗ █████╗ ███████╗██╗   ██╗██╗  ██╗
██║    ██║██╔══██╗╚══███╔╝██║   ██║██║  ██║
██║ █╗ ██║███████║  ███╔╝ ██║   ██║███████║
██║███╗██║██╔══██║ ███╔╝  ██║   ██║██╔══██║
╚███╔███╔╝██║  ██║███████╗╚██████╔╝██║  ██║
 ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                                           

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : File Integrity Monitoring (FIM)

<br>

Doc : https://documentation.wazuh.com/current/proof-of-concept-guide/poc-file-integrity-monitoring.html

Another tutorial on gather user with auditd

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : File Integrity Monitoring (FIM)

<br>

* on wazuh agent in /var/ossec/etc/ossec.conf

```
<syscheck>
...
<directories check_all="yes" report_changes="yes" realtime="yes">/root</directories>
```

PS : change frequency

```
sudo systemctl restart wazuh-agent
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Who-Data Monitoring

<br>

Doc : https://documentation.wazuh.com/current/user-manual/capabilities/file-integrity/advanced-settings.html

* based on auditd packages

```
sudo apt install -y auditd
sudo apt-get install audispd-plugins
sudo systemctl restart auditd
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Who-Data Monitoring

<br>

* on wazuh agent in /var/ossec/etc/ossec.conf

```
<syscheck>
   <directories check_all="yes" whodata="yes">/etc</directories>
</syscheck>
```

```
sudo systemctl restart wazuh-agent
```

* example : follow server allow

```
  <directories check_all="yes" whodata="yes" report_changes="yes">/etc/hosts.allow</directories>
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Who-Data Monitoring

<br>

* define recursion level

```
recursion_level="3"
<nodiff>/appfolder/private-file.conf</nodiff>
```

```
<syscheck>
  <synchronization>
    <enabled>yes</enabled>
    <interval>5m</interval>
    <max_interval>1h</max_interval>
    <response_timeout>30</response_timeout>
    <queue_size>16384</queue_size>
    <max_eps>10</max_eps>
  </synchronization>
</syscheck>
```
