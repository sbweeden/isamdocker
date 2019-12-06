# Get docker container ID for isamconfig container
ISAMCONFIG="$(oc get --no-headers=true pods -l name=isam-config -o custom-columns=:metadata.name)"

# Copy the current snapshots from isamconfig container
SNAPSHOTS=`oc exec ${ISAMCONFIG} ls /var/shared/snapshots`
for SNAPSHOT in $SNAPSHOTS; do
oc cp ${ISAMCONFIG}:/var/shared/snapshots/$SNAPSHOT .
done

