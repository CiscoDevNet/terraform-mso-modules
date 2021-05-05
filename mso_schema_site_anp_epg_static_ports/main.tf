terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
    }
  }
}

provider "mso" {
  username = "admin"
  password = "ins3965!ins3965!"
  url      = "https://173.36.219.193/"
  insecure = true
}


resource "mso_schema_site_anp_epg_static_port" "this" {
    schema_id            = "60848ac2520000aae262ce00"
    site_id              = "601a89a35000004b010dc247"
    template_name        = "Template1"
    anp_name             = "ANP"
    epg_name             = "DB"
    path_type            = "port"
    deployment_immediacy = "lazy"
    pod                  = "pod-4"
    leaf                 = "106"
    path                 = each.value
    for_each             = toset(var.paths)
    vlan                 = 200
    micro_seg_vlan       = 3
    mode                 = "untagged"
    fex                  = "10"
}

// Need below two commands for execution.

// terraform apply -var-file=terraform.tfvars --parallelism=1
// terraform destroy --parallelism=1