### Concepts
* [Terraform_overview](../1_terraform_overview.md)
* [Audio](https://drive.google.com/file/d/1IqMRDwJV-m0v9_le_i2HA_UbM_sIWgWx/view?usp=sharing)

### Prerequisites

Overall, automate the process of adding the HashiCorp repository and installing Terraform on a Debian or Ubuntu-based system.
```
./terraform.sh
```
Add path to google default credential
```
export GOOGLE_APPLICATION_CREDENTIALS="../service-account-key/de-20230222-08a4ff9362e7.json"
```
You will need to give extra permissions for VM instances, dataproc and firewall in IAM roles in service account page in GCP.
- For VM instances, grant the `Compute Admin` role. 
- For Dataproc clusters, grant the `Dataproc Editor` or `Dataproc Admin` role. 
- For firewall rules, grant the `Compute Network Admin` or `Network Admin` role. 


### Execution (Ubuntu setup)

```shell

# Initialize state file (.tfstate): initialize and install the required plugins, 
# for example, google provider in our case and all the existing configuration 
terraform init

# Check changes to new infra plan
terraform plan

# The changes that are detected from the terraform plan, any resources to be deleted 
# or new resources to be created or any existing resources need to be updated in configuration. 
# For example, increasing the memory size of a particular cluster.
terraform apply

# Delete infra after your work, to avoid costs on any running services
terraform destroy
```
