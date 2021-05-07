terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
    }
  }
}

module "mso_schema_site_anp_epg_static_ports" "this" {
  for_each             = toset(var.paths)
  schema_id            = var.schema_id
  site_id              = var.site_id
  template_name        = var.template_name
  anp_name             = var.anp_name
  epg_name             = var.epg_name
  path_type            = var.path_type
  deployment_immediacy = var.deployment_immediacy
  pod                  = var.pod
  leaf                 = var.leaf
  path                 = each.value
  vlan                 = var.vlan
  micro_seg_vlan       = var.micro_seg_vlan
  mode                 = var.mode
  fex                  = var.fex
}

// Need below two commands for execution.

// terraform apply -var-file=terraform.tfvars --parallelism=1
// terraform destroy --parallelism=1