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
  default     = "regula-aks-demo"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network"
  default     = ["10.10.0.0/16"]
}

variable "address_prefix" {
  type        = string
  description = "The address prefix for the subnet"
  default     = "10.10.32.0/19"
}

variable "aks_subnet_name" {
  type        = string
  description = "The name of the subnet to create inside the vNet"
  default     = "aks-subnet"
}

variable "location" {
  type        = string
  description = "Location of cluster, if not defined it will be read from the resource-group"
  default     = "northeurope"
}

variable "os_disk_size_gb" {
  type        = number
  description = "Disk size of nodes in GBs"
  default     = 30
}

variable "sku_tier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are `Free` and `Paid`"
  default     = "Free"
}

variable "agents_min_count" {
  type        = number
  description = "Minimum number of nodes in a pool"
  default     = 1
}

variable "agents_max_count" {
  type        = number
  description = "Maximum number of nodes in a pool"
  default     = 2
}

variable "agents_availability_zones" {
  type        = list(string)
  description = "A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  default     = null
}

variable "agents_size" {
  type        = string
  description = "The default virtual machine size for the Kubernetes agents. Changing this without specifying `var.temporary_name_for_rotation` forces a new resource to be created."
  default     = "Standard_D2_v5"
}

variable "api_server_authorized_ip_ranges" {
  type        = set(string)
  description = "The IP ranges to allow for incoming traffic to the server nodes."
  default     = ["0.0.0.0/0"]
}

variable "enable_docreader" {
  description = "Deploy Docreader helm chart"
  type        = bool
  default     = false
}

variable "docreader_values" {
  description = "Docreader helm values"
  type        = string
  default     = ""
}

variable "docreader_license" {
  description = "Docreader Regula license file"
  type        = string
  default     = ""
}

variable "enable_faceapi" {
  description = "Deploy Faceapi helm chart"
  type        = bool
  default     = false
}

variable "faceapi_values" {
  description = "Faceapi helm values"
  type        = string
  default     = ""
}

variable "face_api_license" {
  description = "Faceapi Regula license file"
  type        = string
  default     = ""
}
