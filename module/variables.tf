variable "subscription_id" {
  type        = string
  description = "Subscription ID for Azure authentication"
}

variable "name" {
  type        = string
  description = "The name for the AKS resources created in the specified Azure Resource Group"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network"
}

variable "address_prefix" {
  type        = string
  description = "The address prefix for the AKS subnet"
}

variable "aks_subnet_name" {
  type        = string
  description = "The name of the subnet for AKS nodes"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
}

variable "os_disk_size_gb" {
  type        = number
  description = "Disk size of nodes in GBs"
}

variable "sku_tier" {
  type        = string
  description = "The SKU Tier for the Kubernetes Cluster. Possible values are `Free`, `Standard`, and `Premium`"

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must be one of: Free, Standard, Premium."
  }
}

variable "agents_min_count" {
  type        = number
  description = "Minimum number of nodes in the pool"
}

variable "agents_max_count" {
  type        = number
  description = "Maximum number of nodes in the pool"
}

variable "agents_availability_zones" {
  type        = list(string)
  description = "Availability Zones for the Node Pool. Changing this forces a new resource."
  default     = null
}

variable "agents_size" {
  type        = string
  description = "VM size for the Kubernetes agent nodes"
}

variable "api_server_authorized_ip_ranges" {
  type        = list(string)
  description = "IP ranges allowed to access the API server."
}
