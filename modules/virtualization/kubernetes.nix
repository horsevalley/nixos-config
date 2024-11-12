
{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    kubernetes
    kubectl
    kubectx
    k3s
    k9s
    fluxcd

  ];

}
