{ nixos-wsl }:
{
  pkgs,
  myConfig,
  myUtils,
  ...
}:
let
  platformConfig = if myUtils.isWSL then (import ./wsl { inherit nixos-wsl; }) else ./linux;
  sys = myConfig.system;
in
{
  imports = [
    platformConfig
  ];

  system.stateVersion = sys.state_version;
  time.timeZone = sys.time_zone;
  networking.hostName = sys.host_name;

  users = {
    defaultUserShell = pkgs.${myConfig.system.shell};
    users.${myConfig.user.name} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      #shell = pkgs.zsh;
      # openssh.authorizedKeys.keys = myConfig.ssh.keys;
      ignoreShellProgramCheck = true;
    };
    users.root.ignoreShellProgramCheck = true;
  };

  environment = {
    sessionVariables = {
      las = "ls -al";
      #  nrsf = "nixos-rebuild switch --flake";
    };
    # sessionVariables = {
    #   GITHUB_TOKEN = myConfig.github.token;
    # };

    #todo: 정리
    systemPackages = with pkgs; [
      nixfmt-rfc-style
      wget
      httpie
      htop
      #git
      #vim
      #tmux
    ];
  };

  # services = {
  #   openssh = {
  #     enable = true;
  #     settings = {
  #       PermitRootLogin = "no";
  #       PasswordAuthentication = false;
  #     };
  #   };
  # };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
