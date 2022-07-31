Cloudflare GKE
==============
Google Cloud Kubernetes Cluster with Nginx Ingress Controller behind Cloudflare Tunnel - Proof of Concepts

This repo contains a proof of concepts on how to leverage Cloudflare's argo tunnels without publicly exposing our services. In this setup we'll use [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine/) as an example, but this works with other services as well.

### What is an Argo Tunnel?
[Argo Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/) provides a secure way to connect your origin to Cloudflare without a publicly routable IP address. With Argo Tunnel, you do not expose an external IP from your infrastructure to the Internet. Instead, a lightweight daemon runs in your infrastructure and creates outbound-only connections to Cloudflare’s edge.

Argo Tunnel offers an easy way to expose web servers securely to the internet, without opening up firewall ports and configuring ACLs. Argo Tunnel also ensures requests route through Cloudflare before reaching the web server, so you can be sure attack traffic is stopped with Cloudflare’s WAF and Unmetered DDoS mitigation, and authenticated with Access if you’ve enabled those features for your account

There are tons of use cases like using exposing internal applications, replacing VPN setup with Cloudflare Access possibilities!

Architecture
============
![gke-cloudflare](./images/cloudflare.png)

Requirements
============
- [Terraform version 4.19.0+ with `terraform` CLI tools](https://www.terraform.io/downloads.html)
- GCP (Google Cloud) CLI setup and [authenticated to a GCP project](https://cloud.google.com/sdk/gcloud/reference/auth/application-default/login) with compute access. 
- Helm CLI [installed](https://helm.sh/docs/intro/install/)
- Domain Name that is controlled by CloudFlare.
- Cloudflare account with Argo enabled
- Service Account [Service accounts](https://cloud.google.com/iam/docs/service-accounts) with permissions required by Terraform to provision the infrastructure.

Cloning from Github
===================
From your terminal go to the directory you want to clone the project into.

```bash
cd path/to/your/directoy
```
Clone the project

```bash
git clone git@github.com:NYARAS/cloudflare-gke.git
```

Configuring the projet environment
==================================
Have the following env variables:
```bash
export TF_VAR_gcp_project_id=
export TF_VAR_cloudflare_account_id=
export TF_VAR_cloudflare_zone=
export TF_VAR_cloudflare_email=
export TF_VAR_cloudflare_token=
export TF_VAR_app_server_vpc_name=
export TF_VAR_app_server_subnet_name=
# optional, defaults to following values
export TF_VAR_gcp_zone=europe-west1-c
export TF_VAR_gcp_region=europe-west1
export TF_VAR_router_name=appserver-router
export TF_VAR_router_nat_name=appserver-router-nat
export TF_VAR_router_compute_address_name=appserver-compute-address
export TF_VAR_router_cluster_name=devops-cluster
export TF_VAR_router_master_ipv4_cidr_block=192.168.0.0/28
export TF_VAR_router_service_account_name=app-server-sa
export TF_VAR_router_nodepool_name=appserver
export TF_VAR_router_zone_dns_edit_name=appserver-dns-edit
export TF_VAR_cloudflare_argo_tunnel_name=appserver-tunne
```

Deployment
==========
1. Create a directory named `google` and move the Service Account Json you created in that directory
2. Run `terraform init`, `terraform plan -out=development.tfplan` and `terraform apply development.tfplan` to deploy the full stack

Setup
=====
Typically takes ~8 mins to fully provision the infrastructure. 

This demo 
- Create Google Cloud Network rosources (VPC, Subnets, NAT)
- Creates a Google Cloud (GCP) Kubernetes Engine (GKE)
- Spins up `nginx-ingress-controller` on GKE cluster using Helm
- Spins up a Cloudflare Tunnel with 2 replicas on GKE cluster and points it to the `nginx-ingress-controller`
- Creates Cloudflare token for managing DNS records in the specified zone and creates Kubernetes secret for `external-dns`
- Spins up `external-dns` to automatically manage DNS records pointing to Cloudflare Tunnel for any Kubernetes ingress resources that use specified Cloudflare zone domain
- Spins up example application by deploying `httpbin` (https://httpbin.yourzone.com)

Cloudflare Tunnel
=================
Deployed Cloudflare Tunnel proxied all traffic to the `nginx-ingress-controller`, which handles the load-balancing based on the ingress resources.

Example of Ingress resource that will expose Kubernetes service through Cloudflare Tunnel by creating a CNAME of `httpbin.yourzone.com` pointing to `gke-tunnel-origin.yourzone.com`.

```yaml
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: httpbin-ingress
  annotations:
    # gke-tunnel-origin.yourzone.com is not proxied CNAME to your tunnel
    # it is created by Terraform in cloudflare-tunnel.tf
    external-dns.alpha.kubernetes.io/target: gke-tunnel-origin.yourzone.com
    ingress.kubernetes.io/rewrite-target: /
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - host: httpbin.yourzone.com
    http:
        paths:
          - pathType: Prefix
            path: /
            backend:
              service:
                name: httpbin
                port:
                  number: 80
```
