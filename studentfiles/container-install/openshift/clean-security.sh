echo "Deleting Service Accounts"
oc delete serviceaccount isam
oc delete serviceaccount openldap

echo "Deleting Security Context Constraint"
oc delete -f isam-security-constraint.yaml

echo "Done."


