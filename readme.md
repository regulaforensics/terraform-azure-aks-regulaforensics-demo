# This module is intended to create Azure AKS cluster and for further regulaforensics Helm charts deployment
## Prerequisites

**Azure**
- Create an **App registration** in the Azure **Active Directory**.
- Go to the **Certificates & secrets** and create a **client secret** for your **App registration**.
- With your subscription, add a **Contributor** role with a member **App registration**.

### Create a terraform main.tf file and pass the required variables: **tenant_id**, **subscription_id**, **client_id**, **client_secret** and **name**. 

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
### To access your cluster, add the following resource:
```hcl
resource "local_file" "kubeconfig" {
  depends_on = [module.aks_cluster]
  filename   = "${path.module}/kubeconfig"
  content    = module.aks_cluster.config
}
```
This will create a kubernetes config file, to access your cluster

## Add the Regula license for your chart:
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
## Execute a terraform template:
```bash
  terraform init
  terraform plan
  terraform apply
```

## Optional. Custom Helm values

### Custom values for docreader chart:
To deploy docreader Helm chart with custom values, take the following steps:
- create a **values.yml** in a folder named by the application (i.e. values/docreader/values.yml)
- pass the file location to the `template_file` of `data source` block:
```hcl
data "template_file" "docreader_values" {
  template = file("${path.module}/values/docreader/values.yml")
}
```
### Custom values for faceapi chart
To deploy faceapi Helm chart with custom values, take the following steps:
- create a **values.yml** in a folder named by the application (i.e. values/faceapi/values.yml)
- pass the file location to the `template_file` of `data source` block:
```hcl
data "template_file" "faceapi_values" {
  template = file("${path.module}/values/faceapi/values.yml")
}
```

Finally, pass the rendered template files to the `docreader_values/faceapi_values` variables:
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
| name                              | The name for the AKS resources created in the specified Azure Resource Group                          | string        | "regula-aks-demo"      |
| address_space                     | The address space that is used by the virtual network                                                 | list(string)  | ["10.10.0.0/16"]       |
| address_prefix                    | The address prefix for the subnet                                                                     | string        | "10.10.32.0/19"        |
| aks_subnet_name                   | A list of public subnets inside the vNet                                                              | string        | "aks-subnet"           |
| location                          | Location of cluster, if not defined it will be read from the resource-group                           | string        | "northeurope"          |
| os_disk_size_gb                   | Disk size of nodes in GBs                                                                             | number        | 30                     |
| sku_tier                          | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are `Free` and `Paid`   | string        | "Free"                 |
| agents_availability_zones         | A list of Availability Zones across which the Node Pool should be spread                              | list(string)  | null                   |
| agents_size                       | The default virtual machine size for the Kubernetes agents                                            | string        | "Standard_D2_v5"       |
| agents_min_count                  | Minimum number of nodes in a pool                                                                     | number        | 1                      |
| agents_max_count                  | Maximum number of nodes in a pool                                                                     | number        | 2                      |
| api_server_authorized_ip_ranges   | The IP ranges to allow for incoming traffic to the server nodes                                       | set(string)   | ["0.0.0.0/0"]          |
| enable_docreader                  | Deploy Docreader Helm chart                                                                           | bool          | false                  |
| docreader_values                  | Docreader Helm values                                                                                 | string        | null                   |
| docreader_license                 | Docreader Regula license file                                                                         | string        | null                   |
| enable_faceapi                    | Deploy Faceapi Helm chart                                                                             | bool          | false                  |
| faceapi_values                    | Faceapi Helm values                                                                                   | string        | null                   |
| face_api_license                  | Faceapi Regula license file                                                                           | string        | null                   |
