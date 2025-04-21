variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-hylastix"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "Sweden Central"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-hylastix"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.1.0.0/24"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "subnet-hylastix"
}

variable "subnet_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
  default     = ["10.1.0.0/25"]
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  default     = "nsg-hylastix"
}

variable "nic_name" {
  description = "Name of the network interface"
  type        = string
  default     = "nic-hylastix"
}

variable "public_ip_name" {
  description = "Name of the public IP address"
  type        = string
  default     = "publicip-hylastix"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-hylastix"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2as_v2"
}


variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = file("${path.module}/my_azure_key.pub")
}
