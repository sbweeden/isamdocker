#!/bin/bash

# Get directory for this script
RUNDIR="`dirname \"$0\"`"         # relative
RUNDIR="`( cd \"$RUNDIR\" && pwd )`"  # absolutized and normalized
if [ -z "$RUNDIR" ] ; then
  echo "Failed to get local path"
  exit 1  # fail
fi

# Get environment from common/env-config.sh
. $RUNDIR/../common/env-config.sh

KEY_DIR=${DOCKERSHARE}/dockerkeys

if [ ! -d "$DOCKERSHARE" ]; then mkdir $DOCKERSHARE; fi
if [ ! -d "$KEY_DIR" ]; then mkdir $KEY_DIR; fi

if [ ! -f "$DOCKERKEYS/openldap/ldap.key" ] || [ ! -f "$DOCKERKEYS/openldap/ldap.crt" ] || [ ! -f "$DOCKERKEYS/openldap/ca.crt" ] || [ ! -f "$DOCKERKEYS/openldap/dhparam.pem" ] || [ ! -f "$DOCKERKEYS/postgresql/server.pem" ]
then
        echo "Not all files created; calling creation script..."
        $RUNDIR/../common/create-ldap-and-postgres-keys.sh
fi

if [ ! -f "$KEY_DIR/openldap/ldap.key" ] || [ ! -f "$KEY_DIR/openldap/ldap.crt" ] || [ ! -f "$KEY_DIR/openldap/ca.crt" ] || [ ! -f "$KEY_DIR/openldap/dhparam.pem" ] || [ ! -f "$KEY_DIR/postgresql/server.pem" ]
then
        echo "Key copy not created; copying now..."
	cp -R $DOCKERKEYS/* $KEY_DIR
fi

docker network create isam
docker volume create isamconfig
docker volume create libldap
docker volume create libsecauthority
docker volume create ldapslapd
docker volume create pgdata

docker run -t -d --restart always -v pgdata:/var/lib/postgresql/data -v ${KEY_DIR}/postgresql:/var/local -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=Passw0rd -e POSTGRES_DB=isam -e POSTGRES_SSL_KEYDB=/var/local/server.pem --hostname postgresql --name postgresql --network isam ibmcom/isam-postgresql:${ISAM_VERSION}

docker run -t -d --restart always -v libldap:/var/lib/ldap -v ldapslapd:/etc/ldap/slapd.d -v libsecauthority:/var/lib/ldap.secAuthority -v ${KEY_DIR}/openldap:/container/service/slapd/assets/certs --hostname openldap --name openldap -e LDAP_DOMAIN=ibm.com -e LDAP_ADMIN_PASSWORD=Passw0rd -e LDAP_CONFIG_PASSWORD=Passw0rd -p ${MY_LMI_IP}:1636:636 --network isam ibmcom/isam-openldap:${ISAM_VERSION} --copy-service

docker run -t -d --restart always -v isamconfig:/var/shared --hostname isamconfig --name isamconfig --cap-add SYS_PTRACE --cap-add SYS_RESOURCE -e CONTAINER_TIMEZONE=Europe/London -e ADMIN_PWD=Passw0rd -p ${MY_LMI_IP}:443:9443 -e SERVICE=config --network isam store/ibmcorp/isam:${ISAM_VERSION}

docker run -t -d --restart always -v isamconfig:/var/shared --hostname isamwrprp1 --name isamwrprp1 --cap-add SYS_PTRACE --cap-add SYS_RESOURCE -e CONTAINER_TIMEZONE=Europe/London -p ${MY_WEB1_IP}:443:443 -e SERVICE=webseal -e INSTANCE=rp1 -e AUTO_RELOAD_FREQUENCY=5 --network isam store/ibmcorp/isam:${ISAM_VERSION}

docker run -t -d --restart always -v isamconfig:/var/shared --hostname isamruntime --name isamruntime --cap-add SYS_PTRACE --cap-add SYS_RESOURCE -e CONTAINER_TIMEZONE=Europe/London -e SERVICE=runtime -e AUTO_RELOAD_FREQUENCY=5 --network isam store/ibmcorp/isam:${ISAM_VERSION}

docker run -t -d --restart always -v isamconfig:/var/shared --hostname isamdsc --name isamdsc --cap-add SYS_PTRACE --cap-add SYS_RESOURCE -e CONTAINER_TIMEZONE=Europe/London -e SERVICE=dsc -e INSTANCE=1 -e AUTO_RELOAD_FREQUENCY=5 --network isam store/ibmcorp/isam:${ISAM_VERSION}

