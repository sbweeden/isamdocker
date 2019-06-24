osadminid=system
osadminpw=admin

echo "Creating Service Accounts"
oc create serviceaccount isam
oc create serviceaccount openldap

echo "Creating Security Context Constraints"
oc create -f security-constraints.yaml --as ${osadminid}:${osadminpw}

echo "Adding service accounts to Security Constraints"
oc adm policy add-scc-to-user isam-scc -z isam --as ${osadminid}:${osadminpw}
oc adm policy add-scc-to-user openldap-scc -z openldap --as ${osadminid}:${osadminpw}
echo "Done."


