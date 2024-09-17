{ config, lib, pkgs, ... }:

let
  cfg = config.programs.abook;
  username = "jonash"; # Replace with your actual username

  populateScript = pkgs.writeScriptBin "populate-abook" ''
    #!${pkgs.python3}/bin/python3
    import csv
    import os

    HOME = os.environ['HOME']
    ABOOK_DIR = os.path.join(HOME, '.config', 'abook')
    ADDRESSBOOK_FILE = os.path.join(ABOOK_DIR, 'addressbook')
    CSV_FILE = '${./cleaned_contacts.csv}'

    def convert_csv_to_abook():
        with open(CSV_FILE, 'r') as csvfile, open(ADDRESSBOOK_FILE, 'w') as abookfile:
            reader = csv.DictReader(csvfile)
            abookfile.write("[format]\nprogram=abook\nversion=0.6.1\n\n")
            for row in reader:
                abookfile.write(f"[{row['Name']}]\n")
                abookfile.write(f"name={row['Name']}\n")
                abookfile.write(f"email={row['E-mail 1 - Value']}\n")
                abookfile.write(f"phone={row['Phone 1 - Value']}\n")
                abookfile.write(f"address={row['Address 1 - Formatted']}\n")
                abookfile.write(f"organization={row['Organization 1 - Name']}\n")
                abookfile.write(f"notes={row['Notes']}\n\n")

    if __name__ == "__main__":
        os.makedirs(ABOOK_DIR, exist_ok=True)
        convert_csv_to_abook()
        print(f"Addressbook populated at {ADDRESSBOOK_FILE}")
  '';

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
    environment.systemPackages = [ cfg.package populateScript ];

    environment.sessionVariables = {
      ABOOK_CONFIG = "$HOME/.config/abook/abookrc";
    };

    system.activationScripts.abook-setup = ''
      mkdir -p /home/${username}/.config/abook
      if [ ! -f /home/${username}/.config/abook/abookrc ]; then
        echo "set database_file=/home/${username}/.config/abook/addressbook" > /home/${username}/.config/abook/abookrc
      fi
      ${populateScript}/bin/populate-abook
      chown -R ${username}:users /home/${username}/.config/abook
      chmod 600 /home/${username}/.config/abook/abookrc /home/${username}/.config/abook/addressbook
    '';
  };
}
