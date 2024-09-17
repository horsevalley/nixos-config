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

  # Custom abook package with hardcoded paths
  customAbook = pkgs.abook.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [
      (pkgs.writeText "abook-custom-paths.patch" ''
        diff --git a/abook.c b/abook.c
        index xxxxxxx..yyyyyyy 100644
        --- a/abook.c
        +++ b/abook.c
        @@ -xxx,7 +xxx,7 @@ init_abook()
         {
         	char *home = getenv("HOME");
         	
        -	snprintf(rcfile, sizeof(rcfile), "%s/.abook/abookrc", home);
        +	snprintf(rcfile, sizeof(rcfile), "%s/.config/abook/abookrc", home);
         	
         	init_opts();
         	
        @@ -yyy,7 +yyy,7 @@ init_abook()
         		strncpy(rcfile, CFG_FILE, sizeof(rcfile));
         	
         	if(!database) {
        -		snprintf(datafile, sizeof(datafile), "%s/.abook/addressbook", home);
        +		snprintf(datafile, sizeof(datafile), "%s/.config/abook/addressbook", home);
         		database = xstrdup(datafile);
         	}
         }
      '')
    ];
  });

in {
  options.programs.abook = {
    enable = lib.mkEnableOption "abook address book manager";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ customAbook ];

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
    '';

    system.activationScripts.abook-setup = ''
      mkdir -p /home/${username}/.config/abook
      cp /etc/abook/addressbook /home/${username}/.config/abook/addressbook
      cp /etc/abook/abookrc /home/${username}/.config/abook/abookrc
      chown -R ${username}:users /home/${username}/.config/abook
    '';
  };
}
