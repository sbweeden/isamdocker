# What's new in IAMLAB SAM v0.7.0 charts
Update to use ibmcom/isam repository (image will no longer be in store)
Update to use 9.0.7.1_IF3 image tag

# What's new in IAMLAB SAM v0.6.0 charts
Update to default to 9.0.7.1_IF2 image tag

# What's new in IAMLAB SAM v0.5.0 charts
This version updates ibm-sch to 1.2.15 required to support Helm 3.x.

# What's new in IAMLAB SAM v0.4.0 charts
This version adds support for Interim Fix images.  The tag parameter (which was appended to all repositories) is removed
Specify the tag as part of the repository dbrepository and ldaprepository parameters instead.

# What's new in IAMLAB SAM v0.3.0 charts
This version uses ISAM 9.0.7.0 images

# What's new in IAMLAB SAM v0.2.0 charts
This version uses ReadWriteOnce disks and, to support this, uses separate PVCs for different containers.

# What's new in IAMLAB SAM v0.1.0 Charts
These charts are based on official IBM Security Access Manager v1.0.0 Charts.

The IAMLAB charts have the following changes:
* The ability to add an OpenLDAP deployment to the release
* The ability to specify a pre-created secret for key material for OpenLDAP and PostgreSQL deployments
* The ability to specify instance names for Reverse Proxy instances

# Prerequisites
1. IBM Cloud Private version 3.1.0 or later

# Documentation (for original IBM Security Access Manager v1.0.0 Charts)
For detailed documentation instructions go to [https://www.ibm.com/support/knowledgecenter/en/SSPREK/welcome.html](https://www.ibm.com/support/knowledgecenter/en/SSPREK/welcome.html).


# Version History

| Chart | Date | Kubernetes Required | Image(s) Supported | Breaking Changes | Details
| ----- | ---- | ------------------- | ------------------ | ---------------- | -------
| 0.7.0 | Feb 2020  | >= 1.11.x | ibmcom/isam:9.0.7.1_IF2; ibmcom/isam-postgresql:9.0.7.0; ibmcom/isam-openldap:9.0.7.0 | docker hub | Based on official 1.0.0 chart
| 0.6.0 | Jan 2020  | >= 1.11.x | store/ibmcorp/isam:9.0.7.1_IF2; ibmcom/isam-postgresql:9.0.7.0; ibmcom/isam-openldap:9.0.7.0 | IF2 | Based on official 1.0.0 chart
| 0.5.0 | Jan 2020  | >= 1.11.x | store/ibmcorp/isam:9.0.7.0_IF1; ibmcom/isam-postgresql:9.0.7.0; ibmcom/isam-openldap:9.0.7.0 | Support Helm 3.0 | Based on official 1.0.0 chart
| 0.4.0 | Sept 2019  | >= 1.11.x | store/ibmcorp/isam:9.0.7.0_IF1; ibmcom/isam-postgresql:9.0.7.0; ibmcom/isam-openldap:9.0.7.0 | Support IF tags | Based on official 1.0.0 chart
| 0.3.0 | July 2019  | >= 1.11.x | store/ibmcorp/isam:9.0.7.0; ibmcom/isam-postgresql:9.0.7.0; ibmcom/isam-openldap:9.0.7.0 | ISAM 9.0.7.0 | Based on official 1.0.0 chart
| 0.2.0 | April 2019 | >= 1.11.x | store/ibmcorp/isam:9.0.6.0; ibmcom/isam-postgresql:9.0.6.0; ibmcom/isam-openldap:9.0.6.0 | ReadWriteOnce Disk | Based on official 1.0.0 chart
| 0.1.0 | February 2019 | >= 1.11.x | store/ibmcorp/isam:9.0.6.0; ibmcom/isam-postgresql:9.0.6.0; ibmcom/isam-openldap:9.0.6.0 | None | Based on official 1.0.0 chart
