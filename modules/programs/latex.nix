{ config, pkgs, lib, ... }:

{
  # Install texlive with the full scheme
  environment.systemPackages = with pkgs; [
    texliveFull
  ];

  # Set up LaTeX-related environment variables
  environment.variables = {
    TEXMFHOME = "$HOME/.texmf";
    TEXMFVAR = "$HOME/.texmf-var";
    TEXMFCONFIG = "$HOME/.texmf-config";
  };

  # Configure system-wide LaTeX settings
  environment.etc = {
    "texmf/texmf.cnf".text = ''
      TEXMFHOME = $HOME/.texmf
      TEXMFVAR = $HOME/.texmf-var
      TEXMFCONFIG = $HOME/.texmf-config
      synctex = 1
    '';
  };

  # Add shell aliases for common LaTeX commands
  environment.shellAliases = {
    latexmk = "latexmk -pdf -pvc";
    cleantex = "rm -f *.aux *.log *.out *.toc *.bbl *.blg *.fls *.fdb_latexmk *.synctex.gz";
  };
}
