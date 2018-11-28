#!/bin/bash
  
# Get directory for this script
RUNDIR="`dirname \"$0\"`"         # relative
RUNDIR="`( cd \"$RUNDIR\" && pwd )`"  # absolutized and normalized
if [ -z "$RUNDIR" ] ; then
  echo "Failed to get local path"
  exit 1  # fail
fi

# Get environment from common/env-config.sh
. $RUNDIR/../../common/env-config.sh

docker build -t iamlab/liberty:1.0 build/wlp

mkdir ${DOCKERSHARE}/wlp-metadata

docker run -d --restart always -p ${MY_WEB1_IP}:9443:9443 -v ${DOCKERSHARE}/wlp-metadata:/config/metadata --name wlp --network isam --hostname  wlp iamlab/liberty:1.0
