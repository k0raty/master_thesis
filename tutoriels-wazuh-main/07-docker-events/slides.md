%title: Wazuh
%author: xavki


██╗    ██╗ █████╗ ███████╗██╗   ██╗██╗  ██╗
██║    ██║██╔══██╗╚══███╔╝██║   ██║██║  ██║
██║ █╗ ██║███████║  ███╔╝ ██║   ██║███████║
██║███╗██║██╔══██║ ███╔╝  ██║   ██║██╔══██║
╚███╔███╔╝██║  ██║███████╗╚██████╔╝██║  ██║
 ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                                           

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Docker Events

<br>

Doc : https://documentation.wazuh.com/current/proof-of-concept-guide/monitoring-docker.html

Monitoring Docker events

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Docker Events

<br>

curl -sSL https://get.docker.com/ | sh
apt install python3 python3-pip
pip3 install docker==4.2.0 urllib3==1.26.18

* activate the docker listener
	1- GUI : Settings > Modules > Threat Detection and Response > Docker listener
	2- configuration file /var/ossec/etc/ossec.conf

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Docker Events

<br>

```
<ossec_config>
  <wodle name="docker-listener">
    <interval>1m</interval>
    <attempts>5</attempts>
    <run_on_start>yes</run_on_start>
    <disabled>no</disabled>
  </wodle>
</ossec_config>
```

```
echo "logcollector.remote_commands=1" >> /var/ossec/etc/local_internal_options.conf
systemctl restart wazuh-agent
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Docker Events

<br>

* test event collect

```
docker pull nginx
docker run -d -P --name nginx_container nginx
docker exec -it nginx_container cat /etc/passwd
docker exec -it nginx_container /bin/bash
exit
docker stop nginx_container
docker rm nginx_container
```

* check in security events : rule.groups=docker

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Docker Events

<br>


