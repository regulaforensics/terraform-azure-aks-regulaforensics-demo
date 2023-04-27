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
  default     = ["10.10.0.0/16"]
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "The address prefix to use for the subnet"
  default     = ["10.10.32.0/19"]
}

variable "subnet_names" {
  type        = list(string)
  description = "A list of public subnets inside the vNet"
  default     = ["subnet1"]
}

variable "location" {
  type        = string
  description = "Location of cluster, if not defined it will be read from the resource-group"
  default     = "North Europe"
}

variable "prefix" {
  type        = string
  description = "The prefix for the resources created in the specified Azure Resource Group"
  default     = "prefix"
}

variable "network_plugin" {
  type        = string
  description = "Network plugin to use for networking"
  default     = "azure"
}

variable "os_disk_size_gb" {
  type        = number
  description = "Disk size of nodes in GBs"
  default     = 50
}

variable "sku_tier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are `Free` and `Paid`"
  default     = "Free"
}

variable "agents_count" {
  type        = number
  description = "The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes."
  default     = 2
}

variable "agents_max_pods" {
  type        = number
  description = "The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  default     = 100
}

variable "agents_availability_zones" {
  type        = list(string)
  description = "A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  default     = ["1", "2", "3"]
}

variable "agents_type" {
  type        = string
  description = "The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets."
  default     = "VirtualMachineScaleSets"
}

variable "agents_size" {
  type        = string
  description = "The default virtual machine size for the Kubernetes agents. Changing this without specifying `var.temporary_name_for_rotation` forces a new resource to be created."
  default     = "Standard_D4_v5"
}

variable "api_server_authorized_ip_ranges" {
  type        = set(string)
  description = "The IP ranges to allow for incoming traffic to the server nodes."
  default     = ["0.0.0.0/0"]
}

variable "net_profile_docker_bridge_cidr" {
  type        = string
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created."
  default     = "172.17.0.1/16"
}

variable "net_profile_service_cidr" {
  type        = string
  description = "The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "net_profile_dns_service_ip" {
  type        = string
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created."
  default     = "10.0.0.10"
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
