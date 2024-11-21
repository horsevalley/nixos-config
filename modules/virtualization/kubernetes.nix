
{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    kubernetes # Production-Grade Container Orchestration, Scheduling and Management
    kubectl # Kubernetes CLI
    kubectx # Fast way to switch between clusters and namespaces in kubectl!
    k3s # A lightweight Kubernetes distribution
    k9s # Kubernetes CLI To Manage Your Clusters In Style
    fluxcd # Open and extensible continuous delivery solution for Kubernetes
    cloudflared # Cloudflare Tunnel daemon, Cloudflare Access toolkit, and DNS-over-HTTPS client

  ];

}
