{ pkgs, myConfig, ... }:
{
  environment.shellAliases = {
    nalias = "cat ${builtins.toString ./.}/aliases.nix | awk '/^[[:space:]]*n[^a][^l][^i][^[:space:]]*[[:space:]]*=/ { match($0, /[[:space:]]*([^[:space:]]+)[[:space:]]*=[[:space:]]*\"([^\"]+)\"/, arr); printf \"%-15s=> %s\\n\", arr[1], arr[2] }'";
    gspm = "git stash push my-config.toml";
    gsp = "git stash pop";
    nrf = "sudo nixos-rebuild switch --flake";
    nrfd = "nrf .";
    nfc = "nix flake check";
    nfcd = "nfc .";
    npull = "pushd /home/${myConfig.user.name}/.dotfiles/${myConfig.nixos.bkp_conf_dir_name} && gspm && git pull --rebase && gsp && popd";
    nupdate = "nrf /home/${myConfig.user.name}/.dotfiles/${myConfig.nixos.bkp_conf_dir_name}";
  };
}
