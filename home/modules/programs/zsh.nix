{ pkgs, myConfig, ... }:

{
  # home.packages = with pkgs; [
  #   git
  # ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "docker"
        "node"
        "npm"
      ];
    };

    /*
      initExtra = ''
        # 커스텀 Zsh 설정
        ${if envType == "wsl" then ''
          # WSL 특화 설정
          alias open="wsl-open"
        '' else ''
          # Linux 특화 설정
          alias open="xdg-open"
        ''}
      '';
    */
  };
}
