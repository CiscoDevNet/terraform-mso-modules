variable "mso_username" {}
variable "mso_password" {}
variable "mso_url" {}

variable "site_id" {
  type    = string
  description = "SiteID under which you want to deploy Static Port."
}

variable "schema_id" {
  type    = string
  description = "SchemaID under which you want to deploy Static Port."
}

variable "template_name" {
  type    = string
  description = "Template name under which you want to deploy Static Port."
}

variable "anp_name" {
  type    = string
  description = "ANP name under which you want to deploy Static Port."
}

variable "epg_name" {
  type    = string
  description = " EPG name under which you want to deploy Static Port."
}

variable "path_type" {
  type    = string
  description = "The type of the static port. Allowed values are port, vpc and dpc."
}

variable "deployment_immediacy" {
  type    = string
  description = "The deployment immediacy of the static port. Allowed values are immediate and lazy."
}

variable "pod" {
  type    = string
  description = "The pod of the static port."
}

variable "leaf" {
  type    = string
  description = "The leaf of the static port."
}

variable "vlan" {
  type    = number
  description = "The port encap VLAN id of the static port."
}

variable "micro_seg_vlan" {
  type    = number
  description = "The microsegmentation VLAN id of the static port."
}

variable "mode" {
  type    = string
  description = "The mode of the static port. Allowed values are native, regular and untagged."
}

variable "fex" {
  type    = string
  description = "Fex-id to be used. This parameter will work only with the path_type as port."
}

variable "paths" {
  type    = list(string)
  description = "The path of the static port."
}