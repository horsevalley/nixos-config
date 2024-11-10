
{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    kubernetes
    kubectl
    k3s
    k9s
    fluxcd

  ];

}
