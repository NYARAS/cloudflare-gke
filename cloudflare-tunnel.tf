resource "random_id" "tunnel_secret" {
  byte_length = 35
}

resource "cloudflare_argo_tunnel" "appserver_tunnel" {
  account_id = var.cloudflare_account_id
  name = var.cloudflare_argo_tunnel_name
  secret = random_id.tunnel_secret.b64_std
}

resource "cloudflare_record" "appserver_tunnel" {
  zone_id = local.cloudflare_zone_id
  name    = "gke-tunnel-origin.${var.cloudflare_zone}"
  value   = "${cloudflare_argo_tunnel.appserver_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = false
}
