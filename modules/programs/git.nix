{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Gamedev
    git
  ];

  programs.git = {
    enable = true;
    userName = "darren_kim";
    userEmail = "terdong@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      #github.user = githubConfig.username;
    };
  };
}
