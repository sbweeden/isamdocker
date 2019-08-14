oc delete all -l app=isam
oc delete all -l app=isamwrprp1
oc delete all -l app=openldap
oc delete all -l app=postgresql
oc delete secret configreader
oc delete secret samadmin
oc delete secret dockerlogin
oc delete secret openldap-keys
oc delete secret postgresql-keys
oc delete pvc -l app=isam
oc delete pvc -l app=openldap
oc delete pvc -l app=postgresql

