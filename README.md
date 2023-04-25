# From Check Point GUI to Terraform IaC and again back to (another) Check Point

* tested with PowerShell
  
### Credentials

* expecting 2 Smart-1 Cloud tenants
* credentials stored in **.env-mtest1.ps1** and **.env-mtest2.ps1** files
* look at .env-mtest1.ps1.sample and .env-mtest2.ps1.sample

```powershell
# provide credentials for TARGET Smart-1 Cloud tenant
cp .env-mtest1.ps1.sample .env-mtest1.ps1
code .env-mtest1.ps1
# provide credentials for SOURCE Smart-1 Cloud tenant
cp .env-mtest2.ps1.sample .env-mtest2.ps1
code .env-mtest1.ps1
```

### Bulk create hosts

Script will create many host objects in mtest2 tenant with common tag.
Next step is importing objects based on this $batchTag.
Script takes credentials from root folder file **.env-mtest2.ps1**.

```powershell
cd ./01prepare
./make-many-hosts.ps1
```

### Import hosts to TF state and create HCL from state

Will continue in second folder and create necessary helper files
that later make it possible to import TF state from CP API and produce HCL code.

```powershell
cd ../02import
# make sure TF has credentials for CP management
. ../.env-mtest2.ps1
# produce **import-hosts.tf** with empty resource blocks
# and **import-hosts.ps1** to import state from CP API
# and **show-hosts.ps1** to dump state in HCL language
./run-import-hosts.ps1
# actual import from CP to TF
./import-hosts.ps1
# dump state in HCL language
./show-hosts.ps1 | sls -NotMatch "id +=" | Out-File ../03execute/hosts.tf -Encoding ascii
```

### Execute generated TF code agains other server to create objects

```powershell
cd ../03execute
# make sure TF has credentials for CP management mtest1
. ../.env-mtest1.ps1
# init
terraform init
# check plan
terraform plan
# execute
terraform apply
# and publish 
terraform apply -var publish=true
# host can be also taken back - deleted
terraform destroy
# and publish - take over session in GUI and publish manually
```