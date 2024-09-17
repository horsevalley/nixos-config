{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.abook;

  # Function to convert a CSV line to abook format
  convertCsvToAbookEntry = line:
    let
      fields = splitString "," line;
      name = elemAt fields 0;
      email = elemAt fields 4;
      phone = elemAt fields 5;
      address = elemAt fields 7;
      organization = elemAt fields 8;
      notes = elemAt fields 9;
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
      csvLines = splitString "\n" csvContent;
      # Skip the header line
      dataLines = tail csvLines;
    in
    concatMapStrings convertCsvToAbookEntry dataLines;

  # Create the abook database file
  abookDbFile = pkgs.writeText "addressbook" ''
    # abook addressbook file

    [format]
    program=abook
    version=0.6.1

    ${abookData}
  '';

  # Create the abook configuration file
  abookConfigFile = pkgs.writeText "abookrc" ''
    set show_all_emails=true
    set add_email_prevent_duplicates=true
    set autosave=true
    set www_command=xdg-open
    set use_mouse=true
  '';

in {
  options.programs.abook = {
    enable = mkEnableOption "abook address book manager";

    package = mkOption {
      type = types.package;
      default = pkgs.abook;
      defaultText = literalExpression "pkgs.abook";
      description = "The abook package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    system.activationScripts.abookSetup = ''
      mkdir -p ~/.config/abook
      cp ${abookDbFile} ~/.config/abook/addressbook
      cp ${abookConfigFile} ~/.config/abook/abookrc
      chmod 600 ~/.config/abook/addressbook ~/.config/abook/abookrc
    '';

    environment.sessionVariables = {
      ABOOK_CONFIG = "$HOME/.config/abook/abookrc";
    };
  };
}
