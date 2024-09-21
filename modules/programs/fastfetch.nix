{ config, lib, pkgs, ... }:

let
  fastfetchConfig = pkgs.writeText "fastfetch-config.jsonc" ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "modules": [
        "title",
        "separator",
        "os",
        "host",
        "kernel",
        "uptime",
        "packages",
        "shell",
        "display",
        "de",
        "wm",
        "wmtheme",
        "theme",
        "icons",
        "font",
        "cursor",
        "terminal",
        "terminalfont",
        "cpu",
        {
          "type": "gpu",
          "key": "GPU",
          "format": "{1} {2} {3}"
        },
        "memory",
        "swap",
        "disk",
        "localip",
        "battery",
        "poweradapter",
        "locale",
        "break",
        "colors"
      ]
    }
  '';
in
{
  environment.systemPackages = [ pkgs.fastfetch ];

  environment.etc."fastfetch/config.jsonc".source = fastfetchConfig;

  system.activationScripts = {
    fastfetchConfig = ''
      mkdir -p /etc/fastfetch
      ln -sf ${fastfetchConfig} /etc/fastfetch/config.jsonc
    '';
  };

  # Optional: Set up an environment variable to point to the config file
  environment.variables = {
    FASTFETCH_CONFIG_FILE = "/etc/fastfetch/config.jsonc";
  };
}
