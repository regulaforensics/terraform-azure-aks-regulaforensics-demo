# This module is intended to create Azure AKS cluster and for further regulaforensics helm charts deployment
## Prerequisites

**Azure**
- Create an **App registration** in the Azure **Active Directory**
- Go to the **Certificates & secrets** and create **client secret** for your **App registration**
- With your subscription add **Contributor** role with member **App registration**

### Create terraform main.tf file and pass required variables **tenant_id**, **subscription_id**, **client_id**, **client_secret** and **name**

```hcl
module "aks_cluster" {
  source            = "github.com/regulaforensics/terraform-azure-regulaforensics-demo"
  name              = var.name
  tenant_id         = var.tenant_id
  subscription_id   = var.subscription_id
  client_id         = var.client_id
  client_secret     = var.client_secret
  location          = var.location
  enable_docreader  = true
  enable_faceapi    = true
}
```
### To access your cluster, add the following resource
```hcl
resource "local_file" "kubeconfig" {
  depends_on = [module.aks_cluster]
  filename   = "${path.module}/kubeconfig"
  content    = module.aks_cluster.config
}
```
This will create a kubernetes config file, to access your cluster

## Add Regula license for your chart
```hcl
data "template_file" "docreader_license" {
  template = filebase64("${path.module}/license/docreader/regula.license")
}
```
```hcl
data "template_file" "face_api_license" {
  template = filebase64("${path.module}/license/faceapi/regula.license")
}
```
```hcl
module "aks_cluster" {
  ...
  docreader_license  = data.template_file.docreader_license.rendered
  face_api_license   = data.template_file.face_api_license.rendered
  ...
}
```
## Execute terraform template
```bash
  terraform init
  terraform plan
  terraform apply
```

## Optional. Custom Helm values

### Custom values for docreader chart
If you are about to deploy docreader Helm chart with custom values:
- create **values.yml** in folder named by application (i.e. values/docreader/values.yml)
- pass file location to the `template_file` of `data source` block
```hcl
data "template_file" "docreader_values" {
  template = file("${path.module}/values/docreader/values.yml")
}
```
### Custom values for faceapi chart
If you are about to deploy faceapi Helm chart with custom values:
- create **values.yml** in folder named by application (i.e. values/faceapi/values.yml)
- pass file location to the `template_file` of `data source` block
```hcl
data "template_file" "faceapi_values" {
  template = file("${path.module}/values/faceapi/values.yml")
}
```

Finally, pass rendered template files to the `docreader_values/faceapi_values` variables
```
module "aks_cluster" {
  source           = "github.com/regulaforensics/terraform-azure-regulaforensics-demo"
  enable_docreader = true
  enable_faceapi   = true
  docreader_values = data.template_file.docreader_values.rendered
  faceapi_values   = data.template_file.faceapi_values.rendered
  ...
}
```



## **Inputs**
| Name                              | Description                                                                                           | Type          |Default                 |
| ----------------------------------|-------------------------------------------------------------------------------------------------------|---------------|------------------------|
| tenant_id                         | The Tenant ID used for Azure Active Directory Application                                             | string        | null                   |
| subscription_id                   | The Subscription ID used for Azure Active Directory Application                                       | string        | null                   |
| client_id                         | The Client ID used for Azure Active Directory Application                                             | string        | null                   |
| client_secret                     | The Client Secret used for Azure Active Directory Application                                         | string        | null                   |
| name                              | The name for the AKS resources created in the specified Azure Resource Group                          | string        | null                   |
| address_space                     | The address space that is used by the virtual network                                                 | list(string)  | ["10.10.0.0/16"]       |
| subnet_prefixes                   | The address prefix to use for the subnet                                                              | list(string)  | ["10.10.32.0/19"]      |
| subnet_names                      | A list of public subnets inside the vNet                                                              | list(string)  | ["subnet1"]            |
| location                          | Location of cluster, if not defined it will be read from the resource-group                           | string        | North Europe           |
| prefix                            | The prefix for the resources created in the specified Azure Resource Group                            | string        | prefix                 |
| network_plugin                    | Network plugin to use for networking                                                                  | string        | azure                  |
| os_disk_size_gb                   | Disk size of nodes in GBs                                                                             | number        | 50                     |
| sku_tier                          | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are `Free` and `Paid`   | string        | Free                   |
| agents_count                      | The number of Agents that should exist in the Agent Pool                                              | number        | 2                      |
| agents_max_pods                   | The maximum number of pods that can run on each agent                                                 | number        | 100                    |
| agents_availability_zones         | A list of Availability Zones across which the Node Pool should be spread                              | list(string)  | ["1", "2", "3"]        |
| agents_type                       | The type of Node Pool which should be created                                                         | string        | VirtualMachineScaleSets|
| agents_size                       | The default virtual machine size for the Kubernetes agents                                            | string        | Standard_D4_v5         |
| api_server_authorized_ip_ranges   | The IP ranges to allow for incoming traffic to the server nodes                                       | set(string)   | ["0.0.0.0/0"]          |
| net_profile_docker_bridge_cidr    | IP address (in CIDR notation) used as the Docker bridge IP address on nodes                           | string        | 172.17.0.1/16          |
| net_profile_service_cidr          | The Network Range used by the Kubernetes service                                                      | string        | 10.0.0.0/16            |
| net_profile_dns_service_ip        | IP address within the Kubernetes service address range that will be used by cluster service discovery | string        | 10.0.0.10              |
| enable_docreader                  | Deploy Docreader helm chart                                                                           | bool          | false                  |
| docreader_values                  | Docreader helm values                                                                                 | string        | null                   |
| docreader_license                 | Docreader Regula license file                                                                         | string        | null                   |
| enable_faceapi                    | Deploy Faceapi helm chart                                                                             | bool          | false                  |
| faceapi_values                    | Faceapi helm values                                                                                   | string        | null                   |
| face_api_license                  | Faceapi Regula license file                                                                           | string        | null                   |
