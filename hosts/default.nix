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
    defaultUserShell = pkgs.nushell;
    users.${myConfig.user.name} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      #shell = pkgs.zsh;
      #openssh.authorizedKeys.keys = myConfig.ssh.keys;
    };
  };

  environment = {
    # sessionVariables = {
    #   GITHUB_TOKEN = myConfig.github.token;
    # };

    systemPackages = with pkgs; [
      nixfmt-rfc-style
      wget
      httpie
      #git
      #vim
      htop
      tmux
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
