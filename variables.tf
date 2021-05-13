# vars here for location
variable "owner" {
  type = string
  default = ""
}

variable "email" {
  type = string
  default = ""
}

variable "purpose" {
  type = string
  default = ""
}

variable "ttl" {
  type = number
  default = "8"
}

variable "terraform" {
  type = bool
  default = true
}

variable "internet_facing" {
  type = bool
  default = false
}

variable "location" {
  type = string
  default = "australiaeast"
}

variable "resource_group_name" {
  type = string
  default = "pcarey-resources"
}

variable "storage_account_name" {
  type = string
  default = "pcareystorage"
}

variable "account_tier" {
  type = string
  default = "Standard"
}

variable "storage_replication_type" {
  type = string
  default = "LRS"
}

variable "vnet_name" {
  type = string
  default = "pcarey-vnet"
}

variable "subnet_name" {
  type = string
  default = "pcarey-subnet"
}

variable "publicip_name" {
  type = string
  default = "pcarey-publicip"
}

variable "nic_name" {
  type = string
  default = "pcarey-nic1"
}

variable "sg_name" {
  type = string
  default = "pcarey-basic-sg"
}

variable "vm_name" {
  type = string
  default = "pcarey-basic-vm"
}

variable "db_user" {
  type = string
  default = "pgadmin"
}

variable "db_name" {
  type = string
  default = "hashicorp"
}

variable "vm_sku" {
  type = string
  default = "Standard_D4_v3"
}

variable "vm_admin_username" {
  type = string
  default = "patrick"
}

variable "vm_count" {
  type = number
  default = 1
}

variable "tfe_key" {
  type = string
  default = "test"
}


variable "ca_public_key_file_path" {
  description = "Write the PEM-encoded CA certificate public key to this path (e.g. /etc/tls/ca.crt.pem)."
  default = "tls/ca.crt.pem" 
}

variable "public_key_file_path" {
  description = "Write the PEM-encoded certificate public key to this path (e.g. /etc/tls/vault.crt.pem)."
  default = "tls/vault.crt.pem" 
}

variable "private_key_file_path" {
  description = "Write the PEM-encoded certificate private key to this path (e.g. /etc/tls/vault.key.pem)."
  default = "tls/vault.key.pem" 
}

variable "active_active" {
  default     = true
  type        = bool
  description = "True if TFE running in active-active configuration"
}

variable "network_frontend_subnet_id" {
  type        = string
  description = "(Required) Azure resource ID of frontend subnet for LB/AG"
}

variable "network_private_ip" {
  default     = ""
  type        = string
  description = "(optional) Private IP address to use for LB/AG endpoint"
}

#variable "network_frontend_subnet_cidr" {
#  default     = "10.0.0.0/20"
  #type        = string
  #description = "(Optional) Public subnet CIDR range for Bastion"
#}


variable "network_allow_range" {
  default     = "*"
  type        = string
  description = "(Optional) Network range to allow access to TFE"
}
