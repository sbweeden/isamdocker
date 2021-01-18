#!/bin/bash

# This script sets up environment variables for use by the rest of the ISAM Docker scripts.
# This script is designed to be sourced from within other scripts so that variables are available on exit.

# If IPs or ISAM Version updated here, you must also run compose/update-env-file.sh to update docker-compose project .env file.
# Kubernetes YAML files do not accept environment variables.  They must be updated by hand.

# IP addresses on local machine used for exposing ports from Docker containers.
# These should be mapped in /etc/hosts to appropriate hostnames

# Bind to isam.iamlab.ibm.com
MY_LMI_IP=127.0.0.2

# Bind to www.iamlab.ibm.com
MY_WEB1_IP=127.0.0.3

# Spare binding if needed
MY_WEB2_IP=127.0.0.4

# Versions
ISAM_VERSION=10.0.1.0
LDAP_VERSION=10.0.1.0
DB_VERSION=10.0.1.0

# Location where Keystores will be created
DOCKERKEYS=${HOME}/dockerkeys

# Location where Docker Shares will be created
# Note that this directory is also hardcoded into YAML files
DOCKERSHARE=${HOME}/dockershare
export DOCKERSHARE

