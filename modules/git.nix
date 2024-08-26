{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.git ];

  environment.etc = {
    "gitconfig".text = ''
      [user]
        name = Jonas Hestdahl
        email = hestdahl@gmail.com
      [core]
        editor = vim
        autocrlf = input
      [init]
        defaultBranch = main
      [color]
        ui = true
      [pull]
        rebase = true
      [alias]
        ga = git add 
        gP = git push 
        gp = git pull 
        gpr = git pull --rebase
        gs = git status 
        gd = git diff 
        gc = git commit 
        gcm = git commit -m 
        gco = git checkout 
        gf = git fetch 
        unstage = reset HEAD --
        last = log -1 HEAD
        visual = !gitk
        gl = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    '';
  };
}
