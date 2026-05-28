variable "subscription_id" {
  type        = string
  description = "Subscription ID for Azure authentication"
}

variable "name" {
  type        = string
  description = "The name for the AKS resources created in the specified Azure Resource Group"
  default     = "regula-aks-demo"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network"
  default     = ["10.10.0.0/16"]
}

variable "address_prefix" {
  type        = string
  description = "The address prefix for the AKS subnet"
  default     = "10.10.32.0/19"
}

variable "aks_subnet_name" {
  type        = string
  description = "The name of the subnet for AKS nodes"
  default     = "aks-subnet"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "northeurope"
}

variable "os_disk_size_gb" {
  type        = number
  description = "Disk size of nodes in GBs"
  default     = 30
}

variable "sku_tier" {
  type        = string
  description = "The SKU Tier for the Kubernetes Cluster. Possible values are `Free`, `Standard`, and `Premium`"
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must be one of: Free, Standard, Premium."
  }
}

variable "agents_min_count" {
  type        = number
  description = "Minimum number of nodes in the pool"
  default     = 1
}

variable "agents_max_count" {
  type        = number
  description = "Maximum number of nodes in the pool"
  default     = 2
}

variable "agents_availability_zones" {
  type        = list(string)
  description = "Availability Zones for the Node Pool. Changing this forces a new resource."
  default     = null
}

variable "agents_size" {
  type        = string
  description = "VM size for the Kubernetes agent nodes"
  default     = "Standard_D2ds_v6"
}

variable "api_server_authorized_ip_ranges" {
  type        = list(string)
  description = "IP ranges allowed to access the API server."
  default     = ["0.0.0.0/0"]
}
