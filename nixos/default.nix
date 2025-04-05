{ pkgs-unstable, nixos-wsl }:
{
  pkgs,
  myConfig,
  myUtils,
  ...
}:
let
  platformConfig =
    if myUtils.isWSL then (import ./platforms/wsl { inherit nixos-wsl; }) else ./platforms/linux;
  sys = myConfig.system;
in
{
  imports = [
    platformConfig
    ./modules
  ];

  system.stateVersion = sys.state_version;
  time.timeZone = sys.time_zone;
  networking.hostName = sys.host_name;
  i18n.defaultLocale = sys.locale;

  users = {
    defaultUserShell = pkgs.${sys.shell}; # global shell
    users.${myConfig.user.name} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
      ];
      #shell = pkgs.${myConfig.system.shell}; # personal shell
      ignoreShellProgramCheck = true;
    };
    users.root.ignoreShellProgramCheck = true;
  };

  environment = {
    systemPackages =
      with pkgs;
      [
        nixfmt-rfc-style
      ]
      ++ (with pkgs-unstable; [
        podman-compose # like docker-compose for podman
        dive # a tool to analyze and inspect Docker containers, images, objects, files, layers, volumes, etc.
        podman-tui # a terminal user interface for managing Podman containers and images
      ]);
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  virtualisation.podman = {
    enable = true;
    package = pkgs-unstable.podman;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune.enable = true;
    dockerCompat = true;
  };
}
