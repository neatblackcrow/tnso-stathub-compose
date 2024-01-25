#!/bin/bash

# Allow ssh with ufw
ufw limit proto tcp from any to 172.19.2.57 port 22 comment 'Allow SSH connections with rate limiting'

# Flush the DOCKER-USER table
iptables -t filter -F DOCKER-USER

# Allow internal docker communications
iptables -t filter -A DOCKER-USER -i br-dotstat -j ACCEPT 

# Allow established connections
iptables -t filter -A DOCKER-USER -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Create a new chain for rate limiting
iptables -t filter -N DOCKER-USER-LIMIT
iptables -t filter -A DOCKER-USER-LIMIT -m limit --limit 100/minute -j LOG --log-prefix "[LIMIT BLOCK]"
iptables -t filter -A DOCKER-USER-LIMIT -j DROP

# Allow HTTP connections to the reverse proxy with rate limiting.
iptables -t filter -A DOCKER-USER -p tcp -d 192.168.192.12 --dport 80 -m conntrack --ctstate NEW -m recent --set
iptables -t filter -A DOCKER-USER -p tcp -d 192.168.192.12 --dport 80 -m conntrack --ctstate NEW -m recent --update --second 30 --hitcount 100 -j DOCKER-USER-LIMIT
iptables -t filter -A DOCKER-USER -p tcp -d 192.168.192.12 --dport 80 -j ACCEPT

# Allow HTTPS connections to the reverse proxy with rate limiting.
iptables -t filter -A DOCKER-USER -p tcp -d 192.168.192.12 --dport 443 -m conntrack --ctstate NEW -m recent --set
iptables -t filter -A DOCKER-USER -p tcp -d 192.168.192.12 --dport 443 -m conntrack --ctstate NEW -m recent --update --second 30 --hitcount 100 -j DOCKER-USER-LIMIT
iptables -t filter -A DOCKER-USER -p tcp -d 192.168.192.12 --dport 443 -j ACCEPT

# Note that databases only accessible via ssh tunneling only.

# DROP everything else routed through this docker host
iptables -t filter -A DOCKER-USER -j DROP

# The default RETURN all. Never reached.
iptables -t filter -A DOCKER-USER -j RETURN

# Allow containers-docker host communications [via INPUT chain]

ufw allow in on br-dotstat proto tcp from 192.168.192.0/20 to 192.168.192.1 comment 'Allow containers-docker host communications [via INPUT chain]'
ufw allow in on br-dotstat proto tcp from 192.168.192.0/20 to 172.19.2.57 comment 'Allow containers-docker host communications [via INPUT chain]'

# ufw allow proto tcp from 192.168.192.12 to 172.19.2.57 port 7001 comment 'Allow communications between .stat Data explorer and reverse proxy'
# ufw allow proto tcp from 192.168.192.12 to 172.19.2.57 port 7000 comment 'Allow communications between .stat Data lifecycle manager and reverse proxy'
# ufw allow proto tcp from 192.168.192.12 to 172.19.2.57 port 81 comment 'Allow communications between NSI webservice design dataspace and reverse proxy'
# ufw allow proto tcp from 192.168.192.12 to 172.19.2.57 port 82 comment 'Allow communications between NSI webservice relese dataspace and reverse proxy'
# ufw allow proto tcp from 192.168.192.12 to 172.19.2.57 port 3004 comment 'Allow communications between SFS solr search and reverse proxy'
# ufw allow proto tcp from 192.168.192.12 to 172.19.2.57 port 8080 comment 'Allow communications between keycloak and reverse proxy'
# ufw allow proto tcp from 192.168.192.12 to 172.19.2.57 port 93 comment 'Allow communications between transfer service and reverse proxy'
# ufw allow proto tcp from 192.168.192.12 to 172.19.2.57 port 94 comment 'Allow communications between NSI auth service and reverse proxy'
# ufw allow proto tcp from 192.168.192.12 to 172.19.2.57 port 3005 comment 'Allow communications between share service and reverse proxy'
# ufw allow proto tcp from 192.168.192.12 to 172.19.2.57 port 7002 comment 'Allow communications between data viewer and reverse proxy'