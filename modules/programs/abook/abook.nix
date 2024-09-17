{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.abook;

  # Custom abook package with patched default directory
  customAbook = pkgs.abook.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [
      (pkgs.writeText "abook-config-dir.patch" ''
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
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ customAbook ];

    system.activationScripts.abookSetup = ''
      mkdir -p $HOME/.config/abook
      cp ${abookDbFile} $HOME/.config/abook/addressbook
      cp ${abookConfigFile} $HOME/.config/abook/abookrc
      chmod 600 $HOME/.config/abook/addressbook $HOME/.config/abook/abookrc
    '';
  };
}
