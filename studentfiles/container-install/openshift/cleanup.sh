oc delete deploy isamruntime
oc delete deploy isamwrprp1
oc delete deploy isamconfig
oc delete deploy openldap
oc delete deploy postgresql
oc delete deploy isamdsc
oc delete service isamconfig
oc delete service isamruntime
oc delete service isamwrprp1
oc delete service openldap
oc delete service postgresql
oc delete service isamdsc
oc delete secret configreader
oc delete secret samadmin
oc delete secret dockerlogin
oc delete secret openldap-keys
oc delete secret postgresql-keys
oc delete pvc isamconfig
oc delete pvc ldaplib
oc delete pvc ldapsecauthority
oc delete pvc ldapslapd
oc delete pvc postgresqldata
oc delete route isamwrprp1
oc delete route isamconfig

