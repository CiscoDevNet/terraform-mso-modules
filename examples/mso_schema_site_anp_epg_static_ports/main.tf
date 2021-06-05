terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
    }
  }
}

provider "mso" {
  username = "someusername"
  password = "somepassword"
  url      = "https://10.0.0.1"
  insecure = true
}

resource "mso_site" "site_test" {
  name             = var.site_name
  username         = var.site_username
  password         = var.site_password
  apic_site_id     = 105
  urls             = ["https://10.0.0.2"]
  location = {
    lat  = 78.946
    long = 95.623
  }
}

resource "mso_tenant" "tenant_test" {
  name         = var.tenant_name
  display_name = var.tenant_name
  site_associations {
    site_id     = mso_site.site_test.id
  }
}

resource "mso_schema" "schema_test" {
  name          = var.schema_name
  template_name = "Template1"
  tenant_id     = mso_tenant.tenant_test.id
}

resource "mso_schema_template_vrf" "vrf" {
  schema_id     = mso_schema.schema_test.id
  template      = mso_schema.schema_test.template_name
  name          = var.vrf_name
  display_name  = var.vrf_name
}

resource "mso_schema_template_bd" "bd" {
  schema_id              = mso_schema.schema_test.id
  template_name          = mso_schema.schema_test.template_name
  name                   = var.bd_name
  display_name           = var.bd_name
  vrf_name               = mso_schema_template_vrf.vrf.name
}

resource "mso_schema_template_anp" "anp" {
  schema_id     = mso_schema.schema_test.id
  template      = mso_schema.schema_test.template_name
  name          = var.anp_name
  display_name  = var.anp_name
}

resource "mso_schema_template_anp_epg" "db" {
  schema_id         = mso_schema.schema_test.id
  template_name     = mso_schema.schema_test.template_name
  anp_name          = mso_schema_template_anp.anp.name
  name              = var.epg_name
  display_name      = var.epg_name
  bd_name           = mso_schema_template_bd.bd.name
  vrf_name          = mso_schema_template_vrf.vrf.name
}

resource "mso_schema_site" "schema_site" {
  schema_id      = mso_schema.schema_test.id
  site_id        = mso_site.site_test.id
  template_name  = mso_schema.schema_test.template_name
}

resource "mso_schema_site_anp" "anp" {
  schema_id     = mso_schema.schema_test.id
  template_name = mso_schema.schema_test.template_name
  site_id       = mso_site.site_test.id
  anp_name      = mso_schema_template_anp.anp.name
}

resource "mso_schema_site_anp_epg" "epg" {
  schema_id     = mso_schema.schema_test.id
  template_name = mso_schema.schema_test.template_name
  site_id       = mso_site.site_test.id
  anp_name      = mso_schema_site_anp.anp.anp_name
  epg_name      = mso_schema_template_anp_epg.db.name
}

module "mso_schema_site_anp_epg_static_ports" {
  source               = "../../mso_schema_site_anp_epg_static_ports"
  schema_id            = mso_schema.schema_test.id
  site_id              = mso_site.site_test.id
  template_name        = mso_schema.schema_test.template_name
  anp_name             = mso_schema_site_anp_epg.epg.anp_name
  epg_name             = mso_schema_site_anp_epg.epg.epg_name
  path_type            = var.path_type
  deployment_immediacy = var.deployment_immediacy
  pod                  = var.pod
  leaf                 = var.leaf
  paths                = var.paths
  vlan                 = var.vlan
  micro_seg_vlan       = var.micro_seg_vlan
  mode                 = var.mode
  fex                  = var.fex
}

// Using same module again with different EPG
resource "mso_schema_template_anp_epg" "web" {
  schema_id         = mso_schema.schema_test.id
  template_name     = mso_schema.schema_test.template_name
  anp_name          = mso_schema_template_anp.anp.name
  name              = "WEB"
  display_name      = "WEB"
  bd_name           = mso_schema_template_bd.bd.name
  vrf_name          = mso_schema_template_vrf.vrf.name
}

resource "mso_schema_site_anp_epg" "epg2" {
  schema_id     = mso_schema.schema_test.id
  template_name = mso_schema.schema_test.template_name
  site_id       = mso_site.site_test.id
  anp_name      = mso_schema_site_anp.anp.anp_name
  epg_name      = mso_schema_template_anp_epg.web.name
}

module "mso_schema_site_anp_epg_static_ports_2" {
  source               = "../../mso_schema_site_anp_epg_static_ports"
  schema_id            = mso_schema.schema_test.id
  site_id              = mso_site.site_test.id
  template_name        = mso_schema.schema_test.template_name
  anp_name             = mso_schema_site_anp_epg.epg2.anp_name
  epg_name             = mso_schema_site_anp_epg.epg2.epg_name
  pod                  = var.pod
  leaf                 = var.leaf
  paths                = var.paths
  vlan                 = var.vlan
}


// Need below two commands for execution.

// terraform apply -var-file=terraform.tfvars --parallelism=1
// terraform destroy --parallelism=1