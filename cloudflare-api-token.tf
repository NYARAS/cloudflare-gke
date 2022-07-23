data "cloudflare_zones" "zones" {
  filter {
    name = var.cloudflare_zone
    lookup_type = "exact"
    status = "active"
  }
}

locals {
  cloudflare_zone_id = lookup(element(data.cloudflare_zones.zones.zones, 0), "id")
}

data "cloudflare_api_token_permission_groups" "all" {
  
}

resource "cloudflare_api_token" "zone_dns_edit" {
  name = var.zone_dns_edit_name
  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.permissions["DNS Write"],
    ]
    resources = {
      "com.cloudflare.api.account.zone.${local.cloudflare_zone_id}" = "*"
    }
  }
}
