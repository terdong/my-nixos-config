{
  #system,
  self,
  pkgs,
  myConfig,
  config,
  #utils,
  ...
}:

let
  flakeRoot = self.outPath;
  userName = myConfig.user.name;
in
#userConfig = myConfig.user;
#githubConfig = config3.github;
#systemConfig = myConfig.system;
#envType = (import ./lib/utils.nix { inherit (pkgs) lib; }).detectEnvironment;
#shouldCreateFile = builtins.pathExists "${flakeRoot}/secrets/id_rsa.pub";
{
  programs.home-manager.enable = true;
  imports = [
    ./modules/programs
  ];

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    stateVersion = myConfig.system.state_version;
    sessionVariables.SHELL = "/etc/profiles/per-user/${userName}/bin/${myConfig.system.shell}";
    file = {
      ".ssh/dummy" = {
        text = "dummy";
        onChange = "
        cp -rf ${myConfig.ssh.private_key_path} $HOME/.ssh/id_rsa
        chmod 600 $HOME/.ssh/id_rsa
        ";
      };
    };

    packages = with pkgs; [
      #${myConfig.programs.terminal}
      #${myConfig.programs.editor}
      #git
      curl
      ripgrep
      fd
      tree
      jq
    ];
    /*
      ++ (
        if envType == "wsl" then
          [
            # WSL 특화 패키지
            wslu
          ]
        else
          [
            # 일반 리눅스 특화 패키지
            firefox
            thunderbird
          ]
      );
    */

    # 환경 변수 설정
    /*
      sessionVariables = {
        EDITOR = myConfig.programs.editor;
        VISUAL = myConfig.programs.editor;
      };
    */
  };

  # 환경별 프로그램 설정
  # 프로그램 설정
  /*
    programs = {
      git = {
        enable = true;
        userName = userConfig.fullName;
        userEmail = userConfig.email;

        extraConfig = {
          github.user = githubConfig.username;
        };
      };

        vscode = {
           enable = true;
           extensions =
             if envType == "wsl" then
               [
                 pkgs.vscode-extensions.ms-vscode-remote.remote-wsl
               ]
             else
               [
                 # 리눅스 환경 확장
                 pkgs.vscode-extensions.ms-vscode.cpptools
               ];
         };
    };
  */
}
