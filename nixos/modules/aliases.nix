{ pkgs, myConfig, ... }:
{
  environment.shellAliases = {
    nrf = "sudo nixos-rebuild switch --flake";
    nrfd = "nrf .";
    nfc = "nix flake check";
    nfcd = "nfc .";
    npull = "pushd /home/${myConfig.user.name}/.dotfiles/${myConfig.nixos.backup_config_directory_name} && git stash push my-config.toml && git pull --rebase && git stash pop && popd";
    nupdate = "nrf /home/${myConfig.user.name}/.dotfiles/${myConfig.nixos.backup_config_directory_name}";
  };
}
