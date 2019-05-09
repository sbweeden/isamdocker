helm delete --purge iamlab
kubectl delete secret helm-samadmin
kubectl delete secret dockerlogin
kubectl delete secret openldap-keys
kubectl delete secret postgresql-keys
kubectl delete ingress iamlab-isamwrp-rp1
