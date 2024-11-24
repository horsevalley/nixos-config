{ config, lib, pkgs, ... }:
{
  sops = {
    age.keyFile = "/home/jonash/.age/age.agekey";
    defaultSopsFile = "/home/jonash/repos/github/jonashestdahl/nixos-config/secrets/secrets.yaml";
    validateSopsFiles = false;  # Add this line
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
