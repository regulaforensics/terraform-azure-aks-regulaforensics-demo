# Azure AKS + Regula Forensics

Terraform module to provision an Azure AKS cluster with ingress support, ready for [Regula Forensics](https://regulaforensics.com/) product deployment (`docreader` and `face-api`).

## Prerequisites

- Terraform >= 1.14
- Azure CLI authenticated (`az login`)

## 1. Deploy the AKS Cluster

```hcl
module "aks_cluster" {
  source          = "github.com/regulaforensics/terraform-azure-regulaforensics-demo"
  subscription_id = "your-subscription-id"
  name            = "regula-aks-demo"
  location        = "northeurope"
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
  --name regula-aks-demo
```

Verify access:

```bash
kubectl get nodes
```

## 3. Deploy Product

### 3.1 Docreader

```bash
# Create namespace
kubectl create namespace docreader

# Create license secret
kubectl create secret generic docreader-license \
  --namespace docreader \
  --from-file=regula.license=./license/docreader/regula.license

# Add Regula Helm repo
helm repo add regulaforensics https://regulaforensics.github.io/helm-charts
helm repo update

# Install docreader
helm install docreader regulaforensics/docreader \
  --namespace docreader \
  --set ingress.enabled=true \
  --set ingress.className=webapprouting.kubernetes.azure.com \
  --set ingress.hosts[0].host=docreader.example.com \
  --set ingress.hosts[0].paths[0].path=/ \
  --set ingress.hosts[0].paths[0].pathType=Prefix
```

Or with a custom values file:

```bash
helm install docreader regulaforensics/docreader \
  --namespace docreader \
  -f values/docreader/values.yaml
```

### 3.2 Deploy Face API

```bash
# Create namespace
kubectl create namespace faceapi

# Create license secret
kubectl create secret generic faceapi-license \
  --namespace faceapi \
  --from-file=regula.license=./license/faceapi/regula.license

# Install face-api
helm install faceapi regulaforensics/faceapi \
  --namespace faceapi \
  --set ingress.enabled=true \
  --set ingress.className=webapprouting.kubernetes.azure.com \
  --set ingress.hosts[0].host=faceapi.example.com \
  --set ingress.hosts[0].paths[0].path=/ \
  --set ingress.hosts[0].paths[0].pathType=Prefix
```

Or with a custom values file:

```bash
helm install faceapi regulaforensics/faceapi \
  --namespace faceapi \
  -f values/faceapi/values.yaml
```

## 4. Get Ingress IP

After deployment, get the external IP to point your DNS records:

```bash
kubectl get svc -n app-routing-system
```

Point your DNS A records (`docreader.example.com`, `faceapi.example.com`) to the `EXTERNAL-IP`.

## Terraform Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `subscription_id` | Azure subscription ID | `string` | — |
| `name` | Name for AKS resources and resource group | `string` | `"regula-aks-demo"` |
| `location` | Azure region | `string` | `"northeurope"` |
| `address_space` | VNet address space | `list(string)` | `["10.10.0.0/16"]` |
| `address_prefix` | AKS subnet prefix | `string` | `"10.10.32.0/19"` |
| `aks_subnet_name` | Subnet name | `string` | `"aks-subnet"` |
| `sku_tier` | AKS SKU tier: `Free`, `Standard`, `Premium` | `string` | `"Free"` |
| `agents_size` | VM size for nodes | `string` | `"Standard_D2_v5"` |
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
