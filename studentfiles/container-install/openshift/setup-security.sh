echo "Creating Service Accounts"
oc create serviceaccount isam
oc create serviceaccount openldap

echo "Creating isam Security Context Constraint"
oc create -f isam-security-constraint.yaml

echo "Adding service accounts to Security Constraints"
oc adm policy add-scc-to-user isam -z isam
oc adm policy add-scc-to-user anyuid -z openldap
echo "Done."


