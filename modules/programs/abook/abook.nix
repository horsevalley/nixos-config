{ config, lib, pkgs, ... }:

let
  cfg = config.programs.abook;
  username = "jonash"; # Replace with your actual username

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

  # Create a wrapper script for abook
  abookWrapper = pkgs.writeScriptBin "abook" ''
    #!${pkgs.bash}/bin/bash
    export HOME_ABOOK_DIR="$HOME/.config/abook"
    export ABOOK_CONFIG="$HOME_ABOOK_DIR/abookrc"
    export ABOOK_DB="$HOME_ABOOK_DIR/addressbook"

    mkdir -p "$HOME_ABOOK_DIR"

    if [ ! -f "$ABOOK_CONFIG" ]; then
      cp /etc/abook/abookrc "$ABOOK_CONFIG"
    fi

    if [ ! -f "$ABOOK_DB" ]; then
      cp /etc/abook/addressbook "$ABOOK_DB"
    fi

    exec ${cfg.package}/bin/abook --datafile "$ABOOK_DB" --config "$ABOOK_CONFIG" "$@"
  '';

in {
  options.programs.abook = {
    enable = lib.mkEnableOption "abook address book manager";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.abook;
      description = "The abook package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ abookWrapper ];

    environment.etc."abook/addressbook".text = ''
      # abook addressbook file

      [format]
      program=abook
      version=0.6.1

      ${abookData}
    '';

    environment.etc."abook/abookrc".text = ''
      set show_all_emails=true
      set add_email_prevent_duplicates=true
      set autosave=true
      set www_command=xdg-open
      set use_mouse=true
      set database_file=$HOME/.config/abook/addressbook
    '';

    system.activationScripts.abook-setup = ''
      mkdir -p /home/${username}/.config/abook
      cp /etc/abook/addressbook /home/${username}/.config/abook/addressbook
      cp /etc/abook/abookrc /home/${username}/.config/abook/abookrc
      chown -R ${username}:users /home/${username}/.config/abook
    '';
  };
}
