{ config, lib, pkgs, ... }:

{
  sops = {
    age.keyFile = "/home/jonash/.age/age.agekey";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets = {
      anthropic_api_key = {
        owner = "jonash";
      };
      github_token = {
        owner = "jonash";
      };
    };
  };
}
