{
  pkgs,
  myConfig,
  ...
}:

{
  system.stateVersion = myConfig.system.state_version;
  time.timeZone = myConfig.system.time_zone;
  networking.hostName = myConfig.system.host_name;

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
      vim
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
