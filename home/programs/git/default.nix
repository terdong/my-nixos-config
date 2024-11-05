{ pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [ git ];

  imports = [ ./aliases.nix ];

  programs.git = with myConfig.user; {
    enable = true;
    userName = full_name;
    userEmail = email;

    extraConfig = {
      core = {
        autocrlf = "input";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
