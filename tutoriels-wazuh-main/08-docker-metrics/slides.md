%title: Wazuh
%author: xavki


██╗    ██╗ █████╗ ███████╗██╗   ██╗██╗  ██╗
██║    ██║██╔══██╗╚══███╔╝██║   ██║██║  ██║
██║ █╗ ██║███████║  ███╔╝ ██║   ██║███████║
██║███╗██║██╔══██║ ███╔╝  ██║   ██║██╔══██║
╚███╔███╔╝██║  ██║███████╗╚██████╔╝██║  ██║
 ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                                           

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Docker Metrics

<br>

Doc : https://wazuh.com/blog/docker-container-security-monitoring-with-wazuh/

Monitoring Docker events

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Docker Events
# WAZUH : Docker Metrics

<br>

* create a wazuh group dedicated to container on master

```
/var/ossec/bin/agent_groups -a -g container -q
```

* add add agent to group container

```
/var/ossec/bin/manage_agents -l
/var/ossec/bin/agent_groups -a -i 001 -g container -q
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Docker Metrics

<br>

* add specific command to gather data on wazuh-manager

```
<agent_config> 
  <!-- Configuration to enable Docker listener module. --> 
  <wodle name="docker-listener"> 
    <interval>1m</interval> 
    <attempts>5</attempts> 
    <run_on_start>yes</run_on_start> 
    <disabled>no</disabled>
   </wodle> 

<!-- Command to extract container resources information. --> 
  <localfile> 
    <log_format>command</log_format> 
    <command>docker stats --format "{{.Container}} {{.Name}} {{.CPUPerc}} {{.MemUsage}} {{.MemPerc}} {{.NetIO}}" --no-stream</command> 
    <alias>docker container stats</alias> 
    <frequency>120</frequency> 
    <out_format>$(timestamp) $(hostname) docker-container-resource: $(log)</out_format> 
  </localfile> 
  <!-- Command to extract container health information. --> 
  <localfile> 
    <log_format>command</log_format> 
    <command>docker ps --format "{{.Image}} {{.Names}} {{.Status}}"</command> 
    <alias>docker container ps</alias> 
    <frequency>120</frequency> 
    <out_format>$(timestamp) $(hostname) docker-container-health: $(log)</out_format> 
  </localfile> 
</agent_config>
```

Frequency : in seconds

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Docker Metrics

<br>

* add docker decoders /var/ossec/etc/decoders/docker_decoders.xml

```
<!-- Decoder for container resources information. -->
<decoder name="docker-container-resource">
  <program_name>^docker-container-resource</program_name>
</decoder>

<decoder name="docker-container-resource-child">
  <parent>docker-container-resource</parent>
  <prematch>ossec: output: 'docker container stats':</prematch>
  <regex>(\S+) (\S+) (\S+) (\S+) / (\S+) (\S+) (\S+) / (\S+)</regex>
  <order>container_id, container_name, container_cpu_usage, container_memory_usage, container_memory_limit, container_memory_perc, container_network_rx, container_network_tx</order>
</decoder>

<!-- Decoder for container health information. -->
<decoder name="docker-container-health">
  <program_name>^docker-container-health</program_name>
</decoder>

<decoder name="docker-container-health-child">
  <parent>docker-container-health</parent>
  <prematch>ossec: output: 'docker container ps':</prematch>
  <regex offset="after_prematch" type="pcre2">(\S+) (\S+) (.*?) \((.*?)\)</regex>
  <order>container_image, container_name, container_uptime, container_health_status</order>
</decoder>
``` 

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Docker Metrics

<br>

* add docker rulesa/var/ossec/etc/rules/docker_rules.xml

```
<group name="container,">
  <!-- Rule for container resources information. -->
  <rule id="100100" level="5">
    <decoded_as>docker-container-resource</decoded_as>
    <description>Docker: Container $(container_name) Resources</description>
    <group>container_resource,</group>
  </rule>
  
  <!-- Rule to trigger when container CPU and memory usage are above 80%. -->
  <rule id="100101" level="12">
    <if_sid>100100</if_sid>
    <field name="container_cpu_usage" type="pcre2">^(0*[8-9]\d|0*[1-9]\d{2,})</field>
    <field name="container_memory_perc" type="pcre2">^(0*[8-9]\d|0*[1-9]\d{2,})</field>
    <description>Docker: Container $(container_name) CPU usage ($(container_cpu_usage)) and memory usage ($(container_memory_perc)) is over 80%</description>
    <group>container_resource,</group>
  </rule>

  <!-- Rule to trigger when container CPU usage is above 80%. -->
  <rule id="100102" level="12">
    <if_sid>100100</if_sid>
    <field name="container_cpu_usage" type="pcre2">^(0*[8-9]\d|0*[1-9]\d{2,})</field>
    <description>Docker: Container $(container_name) CPU usage ($(container_cpu_usage)) is over 80%</description>
    <group>container_resource,</group>
  </rule>  
  
  <!-- Rule to trigger when container memory usage is above 80%. -->
  <rule id="100103" level="12">
    <if_sid>100100</if_sid>
    <field name="container_memory_perc" type="pcre2">^(0*[8-9]\d|0*[1-9]\d{2,})</field>
    <description>Docker: Container $(container_name) memory usage ($(container_memory_perc)) is over 80%</description>
    <group>container_resource,</group>
  </rule>

  <!-- Rule for container health information. -->
  <rule id="100105" level="5">
    <decoded_as>docker-container-health</decoded_as>
    <description>Docker: Container $(container_name) is $(container_health_status)</description>
    <group>container_health,</group>
  </rule>
   
  <!-- Rule to trigger when a container is unhealthy. -->
  <rule id="100106" level="12">
    <if_sid>100105</if_sid>
    <field name="container_health_status">^unhealthy$</field>
    <description>Docker: Container $(container_name) is $(container_health_status)</description>
    <group>container_health,</group>
  </rule>
</group>
```

-----------------------------------------------------------------------------------------------------------                   

# WAZUH : Docker Metrics

<br>

* then restart wazuh manager

```
systemctl restart wazuh-manager
```

* and test with discover

```
rule.id: (100100 OR 100101 OR 100102 OR 100103)
```

then filter on agent.name, data.container_name, data.container_memory_usage, data.container_cpu_usage
