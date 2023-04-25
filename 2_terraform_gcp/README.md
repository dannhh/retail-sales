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

### Generate SSH access
If you connect to VMs using the Google Cloud console or the Google Cloud CLI, Compute Engine creates SSH keys on your behalf. For more information on how Compute Engine configures and stores keys, see [About SSH connections](https://cloud.google.com/compute/docs/instances/ssh).

If you connect to VMs using third party tools or OpenSSH, you need to add a key to your VM before you can connect. If you don't have an SSH key, you must create one. VMs accept the key formats listed in the sshd_config file.

Follow the link instruction: [https://cloud.google.com/compute/docs/connect/create-ssh-keys
](https://cloud.google.com/compute/docs/connect/create-ssh-keys)

On Linux and macOS workstations, use the `ssh-keygen` utility to create a new SSH key pair. The following example creates an RSA key pair.

```
ssh-keygen -t rsa -f ~/.ssh/KEY_FILENAME -C USERNAME -b 2048
ssh-keygen -t rsa -f ~/.ssh/gcp -C de_zc_2023 -b 2048

Output:
Generating public/private rsa key pair.
…
The key's randomart image is:
+---[RSA 2048]----+
|       ...       |
+----[SHA256]-----+

```

Now we created two keys, one is a `private key` and the other key is a `public key`. You don’t need to show the private key to anyone, and the public key can be shared.

```
ls
cp      gcp.pub     id_ed25519      id_ed25519.pub      known_hosts

cat gcp.pub 
ssh-rsa AAAA ... e5m1RW3/43j de_zc_2023
```

Next, we put this public key (ssh-rsa AAAA ... e5m1RW3/43j de_zc_2023) to google cloud. In Compute engine >> Select Metadata >> SSH key tab >> ADD SSH KEY >> put public key >> Save to finish

```
TODO: input gcp_ssh_key_setup.png from images folder for visualize result
```

### Connect to VM instances
Connect to Linux virtual machine (VM) instances that have external IP addresses.
```
ssh -i PATH_TO_PRIVATE_KEY USERNAME@EXTERNAL_IP
ssh -i ~/.ssh/gcp de_zc_2023@35.201.188.31

Output: 
de_zc_2023@kafka-instance:~$
```