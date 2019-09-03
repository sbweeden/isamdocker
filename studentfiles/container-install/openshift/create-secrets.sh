#!/bin/bash

ADMINPW="Passw0rd"
CFGSVCPW="Passw0rd"

# Get directory for this script
RUNDIR="`dirname \"$0\"`"         # relative
RUNDIR="`( cd \"$RUNDIR\" && pwd )`"  # absolutized and normalized
if [ -z "$RUNDIR" ] ; then
  echo "Failed to get local path"
  exit 1  # fail
fi

KEY_DIR="${HOME}/dockerkeys"

if [ ! -f "$KEY_DIR/openldap/ldap.key" ] || [ ! -f "$KEY_DIR/openldap/ldap.crt" ] || [ ! -f "$KEY_DIR/openldap/ca.crt" ] || [ ! -f "$KEY_DIR/openldap/dhparam.pem" ] || [ ! -f "$KEY_DIR/postgresql/server.pem" ]
then
	echo "Not all files created; calling creation script..."
	$RUNDIR/../common/create-ldap-and-postgres-keys.sh
fi

# Create secret for TLS certificates used by this container
echo "Deleting openldap-keys Secret"
oc delete secret openldap-keys > /dev/null 2>&1
echo "Creating OpenLDAP SSL Keys as a Secret"
oc create secret generic "openldap-keys" --from-file "$KEY_DIR/openldap/ldap.crt" --from-file "$KEY_DIR/openldap/ldap.key" --from-file "$KEY_DIR/openldap/ca.crt" --from-file "$KEY_DIR/openldap/dhparam.pem"

echo "Deleting postgresql-keys Secret"
oc delete secret postgresql-keys > /dev/null 2>&1
echo "Creating server.pem as a Secret"
oc create secret generic postgresql-keys --from-file "$KEY_DIR/postgresql/server.pem"

echo "Deleting samadmin Secret"
oc delete secret samadmin > /dev/null 2>&1
echo "Creating samadmin Secret"
ADMINPWB64=`echo -n ${ADMINPW} | base64`
oc create secret generic samadmin
mycommand=`echo -n oc patch secret/samadmin -p \'{\"data\":{\"adminpw\":\"${ADMINPWB64}\"}}\'`
eval $mycommand
echo "Deleting configreader Secret"
oc delete secret configreader > /dev/null 2>&1
echo "Creating configreader Secret"
CFGSVCPWB64=`echo -n ${CFGSVCPW} | base64`
oc create secret generic configreader
mycommand=`echo -n oc patch secret/configreader -p \'{\"data\":{\"cfgsvcpw\":\"${CFGSVCPWB64}\"}}\'`
eval $mycommand
echo "Done."


