# Version Information
These scripts are for IBM Security Access Manager 9.0.7.0.

Scripts for other versions are available as Releases.

# Common Requirements and Setup

These scripts expect to have write access to $HOME and /tmp.

These scripts will create directories at $HOME/dockerkeys and $HOME/dockershare.  If you want to use different directories then you'll need to modify the common/env-config.sh file AND all YAML files.

You will need to have an account on Docker Store.  You will need to register for the store/ibmcorp/isam image in the store.

All passwords set by these scripts are `Passw0rd`.  Obviously this is not a secure password!

# Create Keystores
Before running any other scripts, run `studentfiles/container-install/common/create-ldap-and-postgres-keys.sh`

This will create the $HOME/dockerkeys directory and populate it with keystores for PostgreSQL and OpenLDAP containers.

# Native Docker
To set up a native Docker environment, use the files in studentfiles/container-install/docker.

These scripts will create the $HOME/dockershare directory.

These scripts assume you have the following IP addresses available locally on your Docker system:
- 127.0.0.2 (isam.iamlab.ibm.com)
- 127.0.0.3 (www.iamlab.ibm.com)

If you want to use other local IP addresses then you'll need to modify the common/env-config.sh file.

First, use `docker login` to log in to Docker.

Then run `./docker-setup.sh` script to create docker containers.

You can now connect to the ISAM LMI at https://127.0.0.2

To clean up the docker resources created, run the `./cleanup.sh` script.

# Docker Compose
To set up an environment with docker-compose, use the files in studentfiles/container-install/compose.

These scripts will create the $HOME/dockershare directory.

These scripts assume you have the following IP addresses available locally on your Docker system:
- 127.0.0.2 (isam.iamlab.ibm.com)
- 127.0.0.3 (www.iamlab.ibm.com)

If you want to use other local IP addresses then you'll need to modify the common/env-config.sh file and run `./update-env-file.sh`

First, use `docker login` to log in to Docker.

Run `./create-keyshares.sh` to copy keys to $HOME/dockershare/composekeys directory

Change directory to the `iamlab` directory.

Run command `docker-compose up -d` to create containers.

You can now connect to the ISAM LMI at https://127.0.0.2

To clean up the docker resources created, run `docker-compose down -v` command.

# Kubernetes
To set up an environment using Kubernetes, use the files in studentfiles/container-install/kubernetes.

These scripts assume that you have the `kubectl` utility installed and that it is configured to talk to your cluster.

First, run `./create-docker-store-secret.sh` command and provide your Docker credentials.

Next, run `./create-secrets.sh` command to create the secrets required for the environment.

Finally, run `kubectl create -f <YAML file>` to define the resources required.

There are YAML files for the following environments:
- Minikube (sam-minikube.yaml)
   - Also works with Kubernetes included with Docker CE on Mac
- IBM Cloud (sam-ibmcloud.yaml)
- Google (sam-google.yaml)

Once all pods are running, you can run the `./lmi-access.sh` script to start a port-forward session for access to the LMI.
With this running, you can access LMI using at https://localhost:9443

To access the Reverse Proxy you will need to determine an External IP for a Node in the cluster and then connnect to this using https on port 30443.

For Minikube an Ingress is defined.  This allows direct access to the Reverse Proxy when DNS points www.iamlab.ibm.com to the Minikube ingress controller IP address.

For Google, access to a NodePort requires the following filewall rule to be created:
`gcloud compute firewall-rules create isamwrp-node-port --allow tcp:30443`

# Helm
To set up an environment using Helm, use the files in studentfiles/container-install/helm.

These scripts assume that you have the `kubectl` and `helm` utilities installed and that thy are configured to talk to a cluster where tiller has been installed.  To install tiller to your cluster, use the command `helm init`.

In some systems Tiller will need to be given administration rights to be able to administer the cluster.  In this case, the following commands can be used:
```
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'      
helm init --service-account tiller --upgrade
```

First, run `./create-docker-store-secret.sh` command and provide your Docker credentials.

Next, run `./create-secrets.sh` command to create the secrets required for the environment.

Finally, run `helm-install.sh` to run the helm command to create an Access Manager release.

The output from this command includes the information you will need to connect to the LMI and Reverse Proxy services.

IMPORTANT: The Helm Charts shown here are modified from the charts provided with Access Manager.  The following changes have been made:
- Ability to include an OpenLDAP deployment in the release
- Ability to specify pre-created secrets for key materials for OpenLDAP and PostgreSQL deployments
- Ability to specify the names of Reverse Proxy instances
- Use of ReadWriteOnce PVCs

If you want to be able to restore a configuration archive created in other environments described here, you will need to allow the names used in the other deployments to resolve here.  If your Kubernetes cluster uses CoreDNS, you can use command `kubectl create -f update-coredns.yaml` to add suitable rewrite rules.  Otherwise you will need to manually modify the configuration after deployment to replace hostnames wherever they appear.

The charts used here can be added to IBM Cloud Private by adding a custom repository pointing at:
https://raw.githubusercontent.com/jonpharry/isamdocker/master/studentfiles/container-install/helm/repo

# OpenShift
To set up an environment using OpenShift, use the files in studentfiles/container-install/openshift.

These scripts assume that you have the `oc` utility installed and it is configured to talk to your OpenShift system.

In some OpenShift environments you will need to grant your user (e.g. developer) access to the sudoers groups so that commands to set up the required security context constraints can be executed using system admin privileges.  To grant this permission, use the following commands:

```
oc login -u system:admin -n default
oc create clusterrolebinding developer-sudo --clusterrole=sudoer --user=<user>
```

Now login as your standard user (e.g. developer)

```oc login```

To set up the required security context constaints, run `./setup-security.sh` command.

Next, run `./create-docker-store-secret.sh` command and provide your Docker credentials.

Next, run `./create-secrets.sh` command to create the secrets required for the environment.

Finally, use this command to process the ISAM Template and use the output to deploy:

```
oc process -f sam-openshift-template.yaml | oc create -f -
```

Alternatively, you could import the template into the OpenShift Console and deploy it from there.

Once ISAM is deployed, you can run the `./lmi-access.sh` script to start a port-forward session for access to the LMI.
With this running, you can access LMI using at https://localhost:9443

OpenShift includes a web proxy which can route traffic to the ISAM Reverse Proxy.  You will need to determine the IP address where this is listening and then point www.iamlab.ibm.com to it in your /etc/hosts file.

# Backup and Restore

To backup the state of your environment, use the `./sam-backup....sh` script in the directory for the environment you're using.  The backup tar file created will contain:
- Content of the $HOME/dockerkeys directory
- OpenLDAP directory content
- PostgreSQL database content
- Configuration snapshot from ISAM config container

To restore from a backup, perform these steps:

1. Delete the $HOME/dockerkeys and $HOME/dockershare directories
1. Run `studentfiles/container-install/common/restore-keys.sh <archive tar file>`
1. Complete setup for the environment you want to create (until containers are running)
1. Run `./sam-restore....sh <archive tar file>` to restore configuration.

Note that you will see errors during the restore when it attempts to create LDAP and DB objects that already exist.


# License

The contents of this repository are open-source under the Apache 2.0 licence.

```
Copyright 2018 International Business Machines

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
