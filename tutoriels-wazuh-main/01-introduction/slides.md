%title: Wazuh
%author: xavki


██╗    ██╗ █████╗ ███████╗██╗   ██╗██╗  ██╗
██║    ██║██╔══██╗╚══███╔╝██║   ██║██║  ██║
██║ █╗ ██║███████║  ███╔╝ ██║   ██║███████║
██║███╗██║██╔══██║ ███╔╝  ██║   ██║██╔══██║
╚███╔███╔╝██║  ██║███████╗╚██████╔╝██║  ██║
 ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                                           

-----------------------------------------------------------------------------------------------------------                                          

# WAZUH : introduction - what is it ?


Security : 

		* SIEM : Security Information and Event Management

		* XDR : Extended Detection and Response

Official Website : https://wazuh.com/
Github : https://github.com/wazuh/wazuh
Language : C/Python
Version : 4.7.2

-----------------------------------------------------------------------------------------------------------                                          

# WAZUH : introduction - what is it ?


SIEM :

		* log centralization

		* vulnerability detection

		* SCA (Security Configuration Assessment) : check with Center for Internet Security (CIS)

		* Check compliance with various framework (PCI DSS, NIST 800-53, GDPR, TSC SOC2, and HIPAA)

		* alerting & notifications

		* insights


-----------------------------------------------------------------------------------------------------------                                          

# WAZUH : introduction - what is it ?


XDR :

		* threat hunting (be focus on analyze)

		* behavioral analysis : detect unusual patterns

		* automated response : dedicated module

		* cloud workload protection : cloud and container security (with/without k8s)

		* threat intelligence : open source intelligence (OSINT) & open data

-----------------------------------------------------------------------------------------------------------                                          

# WAZUH : introduction - what is it ?


Core : 

		* indexer (opensearch)

		* server : receive data from agents & filebeat (roles master/worker)

		* dashboard : GUI with general and custom dashboard

-----------------------------------------------------------------------------------------------------------                                          

# WAZUH : introduction - what is it ?


Agent : 

		* windows, linux, aix, apple, solaris...

		* log collector

		* agentd

		* execd

		* script

-----------------------------------------------------------------------------------------------------------                                          

# WAZUH : introduction - what is it ?


Installation :

		* sources

		* docker

		* kubernetes

		* image ova

Version cloud : not free
