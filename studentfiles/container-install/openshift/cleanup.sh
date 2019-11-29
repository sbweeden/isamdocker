oc delete all -l app=isam-core
oc delete all -l app=isam-rp1
oc delete all -l app=openldap
oc delete all -l app=postgresql
oc delete secret -l app=isam-core
oc delete secret -l app=openldap
oc delete secret -l app=postgresql
oc delete secret openldap-keys
oc delete secret postgresql-keys
oc delete pvc -l app=isam-core
oc delete pvc -l app=openldap
oc delete pvc -l app=postgresql

