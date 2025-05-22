variable "tenant_id" {
  type        = string
  description = "tenant_id of your account"
}

variable "subscription_id" {
  type        = string
  description = "subscription_id of your account"
}

variable "client_id" {
  type        = string
  description = "client_id of your account"
}

variable "client_secret" {
  type        = string
  description = "client_secret of your account"
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
  description = "The address prefix for the subnet"
}

variable "aks_subnet_name" {
  type        = string
  description = "A list of public subnets inside the vNet"
}

variable "location" {
  type        = string
  description = "Location of cluster, if not defined it will be read from the resource-group"
}

variable "os_disk_size_gb" {
  type        = number
  description = "Disk size of nodes in GBs"
}

variable "sku_tier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are `Free` and `Paid`"
}

variable "agents_min_count" {
  type        = number
  description = "Minimum number of nodes in a pool"
}

variable "agents_max_count" {
  type        = number
  description = "Maximum number of nodes in a pool"
}

variable "agents_availability_zones" {
  type        = list(string)
  description = "A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
}

variable "agents_size" {
  type        = string
  description = "The default virtual machine size for the Kubernetes agents. Changing this without specifying `var.temporary_name_for_rotation` forces a new resource to be created."
}

variable "api_server_authorized_ip_ranges" {
  type        = set(string)
  description = "The IP ranges to allow for incoming traffic to the server nodes."
}

variable "enable_docreader" {
  description = "Deploy Docreader helm chart"
  type        = bool
}

variable "docreader_values" {
  description = "Docreader helm values"
  type        = string
}

variable "docreader_license" {
  description = "Docreader Regula license file"
  type        = string
}

variable "enable_faceapi" {
  description = "Deploy Faceapi helm chart"
  type        = bool
}

variable "faceapi_values" {
  description = "Faceapi helm values"
  type        = string
}

variable "face_api_license" {
  description = "Faceapi Regula license file"
  type        = string
}
