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

  # Create a custom abook script
  customAbook = pkgs.writeScriptBin "abook" ''
    #!${pkgs.python3}/bin/python3
    import os
    import sys
    import configparser

    HOME = os.environ['HOME']
    CONFIG_DIR = os.path.join(HOME, '.config', 'abook')
    CONFIG_FILE = os.path.join(CONFIG_DIR, 'abookrc')
    DATABASE_FILE = os.path.join(CONFIG_DIR, 'addressbook')

    def ensure_config():
        os.makedirs(CONFIG_DIR, exist_ok=True)
        if not os.path.exists(CONFIG_FILE):
            with open(CONFIG_FILE, 'w') as f:
                f.write("""
                set show_all_emails=true
                set add_email_prevent_duplicates=true
                set autosave=true
                set www_command=xdg-open
                set use_mouse=true
                set database_file=~/.config/abook/addressbook
                """)
        if not os.path.exists(DATABASE_FILE):
            with open(DATABASE_FILE, 'w') as f:
                f.write("""
                # abook addressbook file

                [format]
                program=abook
                version=0.6.1

                ${abookData}
                """)

    def main():
        ensure_config()
        print("Custom abook script")
        print("Config file: {}".format(CONFIG_FILE))
        print("Database file: {}".format(DATABASE_FILE))
        
        # Here you would implement the actual abook functionality
        # For now, we'll just print the contents of the addressbook
        config = configparser.ConfigParser()
        config.read(DATABASE_FILE)
        for section in config.sections():
            if section != 'format':
                print("\nName: {}".format(config[section].get('name', '')))
                print("Email: {}".format(config[section].get('email', '')))
                print("Phone: {}".format(config[section].get('phone', '')))

    if __name__ == "__main__":
        main()
  '';

in {
  options.programs.abook = {
    enable = lib.mkEnableOption "custom abook script";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ customAbook ];

    system.activationScripts.abook-setup = ''
      mkdir -p /home/${username}/.config/abook
      chown -R ${username}:users /home/${username}/.config/abook
    '';
  };
}
