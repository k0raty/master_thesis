#!/usr/bin/env bash

# Remove the credentials.txt file if it exists
if [ -f /vagrant/credentials.txt ]; then
  rm /vagrant/credentials.txt
  echo "credentials.txt file removed."
else
  echo "credentials.txt file does not exist."
fi
