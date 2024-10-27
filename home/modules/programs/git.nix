{ pkgs, myConfig, ... }:

{
  home.packages = with pkgs; [
    # Gamedev
    git
  ];

  programs.git = with myConfig.user; {
    enable = true;
    userName = full_name;
    userEmail = email;

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      #github.user = githubConfig.username;
    };
  };
}
