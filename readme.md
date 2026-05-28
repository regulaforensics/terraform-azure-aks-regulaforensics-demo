# Azure AKS + Regula Forensics

Terraform module to provision an Azure AKS cluster with managed NGINX ingress, workload identity, Azure Blob Storage, and Azure SQL Serverless — ready for [Regula Forensics](https://regulaforensics.com/) product deployment (`docreader` and `face-api`).

## Prerequisites

- Terraform >= 1.14
- Azure CLI authenticated (`az login`)
- Helm 3
- Azure RBAC: the authenticated identity needs the following roles on the target subscription:
  - **Contributor** — create/manage resource groups, AKS, VNet, Storage, SQL, and related resources
  - **Role Based Access Control Administrator** or **User Access Administrator** — assign managed identity roles
- regula.license file ([get a trial license](https://docs.regulaforensics.com/develop/doc-reader-sdk/overview/licensing/#trial-license))

## 1. Deploy the AKS Cluster

```hcl
module "aks_cluster" {
  source          = "github.com/regulaforensics/terraform-azure-regulaforensics-demo"
  subscription_id = "your-subscription-id"
  name            = "regula-aks-demo"
  location        = "westeurope"
}
```

```bash
terraform init
terraform plan
terraform apply
```

## 2. Get AKS Credentials

```bash
az aks get-credentials \
  --resource-group regula-aks-demo \
  --name regula-aks-demo \
  --overwrite-existing

kubectl get nodes
```

## 3. Deploy Regula Products

### Add Helm repo

```bash
helm repo add regulaforensics https://regulaforensics.github.io/helm-charts
helm repo update
```

### Deploy Docreader

```bash
kubectl create namespace docreader

kubectl create secret generic docreader-license \
  --namespace docreader \
  --from-file=regula.license=./license/docreader/regula.license

helm install docreader regulaforensics/docreader \
  --namespace docreader \
  --set serviceAccount.annotations.'azure\.workload\.identity/client-id'=$(terraform output -raw workload_identity_client_id) \
  --set 'ingress.hosts[0]=docreader.example.com' \
  --set config.service.storage.az.storageAccount=$(terraform output -raw storage_account_name) \
  --set config.service.processing.results.location.container=$(terraform output -raw storage_container_name)
  -f docreader.values.yaml
```

### Deploy Face API

```bash
kubectl create namespace faceapi

kubectl create secret generic faceapi-license \
  --namespace faceapi \
  --from-file=regula.license=./license/faceapi/regula.license

helm install faceapi regulaforensics/faceapi \
  --namespace faceapi \
  --set serviceAccount.annotations.'azure\.workload\.identity/client-id'=$(terraform output -raw workload_identity_client_id) \
  --set 'ingress.hosts[0]=faceapi.example.com' \
  --set config.service.storage.az.storageAccount=$(terraform output -raw storage_account_name) \
  --set config.service.detectMatch.results.location.container=$(terraform output -raw storage_container_name) \
  --set config.service.liveness.sessions.location.container=$(terraform output -raw storage_container_name) \
  --set config.service.database.connectionString="$(terraform output -raw database_connection_string)" \
  -f faceapi.values.yaml
```

> **Note:** The federated identity credentials are pre-configured for service accounts `docreader` in namespace `docreader` and `faceapi` in namespace `faceapi`. If your chart uses different names, update the `subject` in `module/storage.tf`.

## 4. Get Ingress IP

```bash
kubectl get svc -n app-routing-system
```

Point your DNS A records (`docreader.example.com`, `faceapi.example.com`) to the `EXTERNAL-IP`.

## 5. (Optional) Add TLS Certificate

```bash
kubectl create secret tls docreader-tls \
  --namespace docreader \
  --cert=./certs/tls.crt \
  --key=./certs/tls.key

kubectl create secret tls faceapi-tls \
  --namespace faceapi \
  --cert=./certs/tls.crt \
  --key=./certs/tls.key
```

Then upgrade with TLS:

```bash
helm upgrade docreader regulaforensics/docreader \
  --namespace docreader \
  --reuse-values \
  --set 'ingress.tls[0].secretName=docreader-tls' \
  --set 'ingress.tls[0].hosts[0]=docreader.example.com'
```

## Terraform Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `subscription_id` | Azure subscription ID | `string` | — |
| `name` | Name for AKS resources and resource group | `string` | `"regula-aks-demo"` |
| `location` | Azure region | `string` | `"westeurope"` |
| `address_space` | VNet address space | `list(string)` | `["10.10.0.0/16"]` |
| `address_prefix` | AKS subnet prefix | `string` | `"10.10.32.0/19"` |
| `aks_subnet_name` | Subnet name | `string` | `"aks-subnet"` |
| `sku_tier` | AKS SKU tier: `Free`, `Standard`, `Premium` | `string` | `"Free"` |
| `agents_size` | VM size for nodes | `string` | `"Standard_D2ds_v6"` |
| `os_disk_size_gb` | Node OS disk size | `number` | `30` |
| `agents_min_count` | Min nodes (autoscaler) | `number` | `1` |
| `agents_max_count` | Max nodes (autoscaler) | `number` | `2` |
| `agents_availability_zones` | AZ spread for nodes | `list(string)` | `null` |
| `api_server_authorized_ip_ranges` | Allowed CIDRs for API server | `list(string)` | `["0.0.0.0/0"]` |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_name` | Resource group / cluster name |
| `config` | Kubeconfig YAML (sensitive) |
| `storage_account_name` | Azure Blob Storage account name |
| `storage_container_name` | Azure Blob Storage container name |
| `workload_identity_client_id` | Managed identity client ID for workload identity |
| `database_connection_string` | Azure SQL connection string (passwordless auth via workload identity) |
