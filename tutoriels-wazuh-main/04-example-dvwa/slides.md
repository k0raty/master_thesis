%title: Wazuh
%author: xavki


██╗    ██╗ █████╗ ███████╗██╗   ██╗██╗  ██╗
██║    ██║██╔══██╗╚══███╔╝██║   ██║██║  ██║
██║ █╗ ██║███████║  ███╔╝ ██║   ██║███████║
██║███╗██║██╔══██║ ███╔╝  ██║   ██║██╔══██║
╚███╔███╔╝██║  ██║███████╗╚██████╔╝██║  ██║
 ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                                           

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : DVWA & Teler

<br>

Doc : https://wazuh.com/blog/detecting-web-attacks-using-wazuh-and-teler/

DVWA : test intrusion website
  Damn Vulnerable Web Application
	https://github.com/opsxcq/docker-vulnerable-dvwa

Teler : realtime intrusion detection based on log
	https://github.com/kitabisa/teler/

Nikto : security scanner in perl
	https://doc.ubuntu-fr.org/nikto

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : DVWA & Teler

<br>

* install dvwa

```
curl -fsSL https://get.docker.com | bash 2>&1 >/dev/null
mkdir logs /var/log/teler
docker run --rm -d -v ./logs/:/var/log/apache2/ -p 80:80 vulnerables/web-dvwa
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : DVWA & Teler

<br>

* install teler

```
wget https://github.com/kitabisa/teler/releases/download/v2.0.0-rc.3/teler_2.0.0-rc.3_linux_amd64.tar.gz
tar -xvzf teler_2.0.0-rc.3_linux_amd64.tar.gz
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : DVWA & Teler

<br>

* teler settings in teler.yml

```
log_format: |
  $remote_addr - $remote_user [$time_local] "$request_method $request_uri $request_protocol" $status $body_bytes_sent "$http_referer" "$http_user_agent"
logs:
  file:
    active: true 
    json: true 
    path: /var/log/teler/output.log
```


-----------------------------------------------------------------------------------------------------------                   

# WAZUH : DVWA & Teler

<br>

* configure agent to check output.log
	edit /var/ossec/etc/ossec.conf

```
  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/teler/output.log</location>
  </localfile>
```

systemctl restart wazuh-agent

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : DVWA & Teler

<br>

* add an active response on the manager

```
  <active-response>
    <disabled>no</disabled>
    <command>firewall-drop</command>
    <location>local</location>
    <rules_id>100012,100013,100014</rules_id>
    <timeout>360</timeout>
  </active-response>
```

systemctl restart wazuh-manager

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : DVWA & Teler

<br>

* activate teler to read apache logs

tail -f ./logs/access.log | ./teler -c teler.yml


-----------------------------------------------------------------------------------------------------------                   

# WAZUH : DVWA & Teler

<br>

* edit /var/ossec/etc/rules/local_rules.xml
	https://attack.mitre.org/


```
<group name="teler,">
 <rule id="100012" level="10">
   <decoded_as>json</decoded_as>
   <field name="category" type="pcre2">Common Web Attack(: .*)?|CVE-[0-9]{4}-[0-9]{4,7}</field>
   <field name="request_uri" type="pcre2">\D.+|-</field>
   <field name="remote_addr" type="pcre2">\d+.\d+.\d+.\d+|::1</field>
   <mitre>
     <id>T1210</id>
   </mitre>
   <description>teler detected $(category) against resource $(request_uri) from $(remote_addr)</description>
 </rule>
 <rule id="100013" level="10">
   <decoded_as>json</decoded_as>
   <field name="category" type="pcre2">Bad (IP Address|Referrer|Crawler)</field>
   <field name="request_uri" type="pcre2">\D.+|-</field>
   <field name="remote_addr" type="pcre2">\d+.\d+.\d+.\d+|::1</field>
   <mitre>
     <id>T1590</id>
   </mitre>
   <description>teler detected $(category) against resource $(request_uri) from $(remote_addr)</description>
 </rule>
 <rule id="100014" level="10">
   <decoded_as>json</decoded_as>
   <field name="category" type="pcre2">Directory Bruteforce</field>
   <field name="request_uri" type="pcre2">\D.+|-</field>
   <field name="remote_addr" type="pcre2">\d+.\d+.\d+.\d+|::1</field>
   <mitre>
     <id>T1595</id>
   </mitre>
   <description>teler detected $(category) against resource $(request_uri) from $(remote_addr)</description>
 </rule>
</group>
```

systemctl restart wazuh-manager

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : DVWA & Teler

<br>

* test with nikto

```
sudo apt install nikto
nikto -h http://192.168.12.183/dvwa
```
