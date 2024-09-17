{ config, lib, pkgs, ... }:

let
  cfg = config.programs.abook;

  # Function to convert a CSV line to abook format
  convertCsvToAbookEntry = line:
    let
      fields = builtins.split "," line;
      name = builtins.elemAt fields 0;
      email = builtins.elemAt fields 4;
      phone = builtins.elemAt fields 5;
      address = builtins.elemAt fields 7;
      organization = builtins.elemAt fields 8;
      notes = builtins.elemAt fields 9;
    in
    ''
      [${name}]
      name=${name}
      email=${email}
      phone=${phone}
      address=${address}
      organization=${organization}
      notes=${notes}
    '';

  # Read the CSV file and convert it to abook format
  abookData = 
    let
      csvContent = builtins.readFile ./cleaned_contacts.csv;
      csvLines = builtins.filter (line: line != "") (builtins.split "\n" csvContent);
      # Skip the header line
      dataLines = builtins.tail csvLines;
    in
    builtins.concatStringsSep "\n" (map convertCsvToAbookEntry dataLines);

in
{
  options.programs.abook = {
    enable = lib.mkEnableOption "abook address book manager";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.abook;
      description = "The abook package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.sessionVariables = {
      ABOOK_CONFIG = "$XDG_CONFIG_HOME/abook/abookrc";
    };

    environment.variables = {
      XDG_CONFIG_HOME = "$HOME/.config";
    };

    system.activationScripts.abook-setup = ''
      mkdir -p $HOME/.config/abook
      if [ ! -f $HOME/.config/abook/abookrc ]; then
        echo "set database_file=$HOME/.config/abook/addressbook" > $HOME/.config/abook/abookrc
      fi
      cat > $HOME/.config/abook/addressbook <<EOL
      # abook addressbook file

      [format]
      program=abook
      version=0.6.1

      ${abookData}
      EOL
      chmod 600 $HOME/.config/abook/abookrc $HOME/.config/abook/addressbook
    '';
  };
}
