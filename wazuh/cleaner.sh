#!/usr/bin/env bash
# CLEANER FILE - REMOVE EVERY FILES THAT MAY CREATE CONFLICT IF NOT REMOVED BEFORE BUILDING MACHINES # 

# Clear the contents of credentials.txt if it exists
if [ -f /vagrant/credentials.txt ]; then
  > /vagrant/credentials.txt
  echo "credentials.txt file cleared."
else
  echo "credentials.txt file does not exist."
fi

# Add a message to the credentials.txt file
echo "Please, check the IP's to ensure there isn't any conflict" >> /vagrant/credentials.txt
