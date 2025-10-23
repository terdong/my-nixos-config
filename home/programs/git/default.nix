{ pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [ git ];

  imports = [ ./aliases.nix ];

  programs.git = with myConfig.user; {
    enable = true;

    settings = {
      user.name = full_name;
      user.email = email;
      core = {
        autocrlf = "input";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
