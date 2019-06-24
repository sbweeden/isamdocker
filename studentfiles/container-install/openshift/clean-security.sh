osadminid=system
osadminpw=admin

echo "Deleting Service Accounts"
oc delete serviceaccount isam
oc delete serviceaccount openldap

echo "Deleting Security Context Constraints"
oc delete -f security-constraints.yaml --as ${osadminid}:${osadminpw}

echo "Done."


