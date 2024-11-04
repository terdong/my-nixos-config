# Simple NixOS + Home Manager Configuration with Flakes

>**Warning**: This project **only works on WSL** environments. It is not guaranteed to work on general Linux yet.

This repository provides a simple and modular Nix Flake setup for configuring a NixOS system and Home Manager. It’s designed to make managing a NixOS system with user-specific configurations more scalable and reproducible.

## Features

* [x] NixOS system configuration
* [x] Home Manager integration for user environments
* [x] Managing settings via external file(my-config.toml)
* [x] Supports private ssh key via ssh.private_key_path in my-coinfig.toml
* [x] Supports Direnv(nix-direnv)
* [x] Supports VS Code for WSL
* [x] Supports win32yank for clipboard sync
* [ ] Supports Docker
* [ ] Supports Linux
* [ ] More useful packages

## Requirements

- This guide is based on the WSL environment installed on Windows OS.
- Download [the latest version](https://github.com/nix-community/NixOS-WSL/releases/latest) of NixOS-WSL.
  - Refer to [this site](https://github.com/nix-community/NixOS-WSL) to install it.
- **Nix** with experimental features enabled for Flakes:
  - To enable Flakes, add `experimental-features = nix-command flakes` to your `~/.config/nix/nix.conf`.
- If you successfully entered the basic shell(probably "bash") of the NixOS by entering the command below preparations are complete in **cmd** or **power shell**, you are ready.
  ```powershell
  wsl -d NixOS
  ```

## Getting Started

### 0. Let's proceed assuming that you are in the shell such as bash of NixOS.

### 1. Enable experimental features for Flakes
The following settings are required to use the commands below.
```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
```

### 2. Install Git, Vim on nix shell

Since git and vim are not installed on NixOS-WSL, install them in the nix-shell environment.
```bash
nix shell nixpkgs#git nixpkgs#vim
```
### 3. Clone the Repository

```bash
cd /tmp #or wherever you want
git clone https://github.com/terdong/my-nixos-config
cd my-nixos-config
```

### 4. Edit your settings in ./my-config.toml
```bash
vi my-config.toml
```
- <ins>_**It must be changed, especially:**_</ins>
  ```toml
  [user]
  name = "YOUR_NAME" #<- Change it to whatever name you want.
  ```

### 5. Initialize NixOS with Flakes

```bash
sudo nixos-rebuild switch --flake .
```

### 6. Reboot NixOS

- After exiting the shell, reboot NixOS-WSL with the following command in cmd or powershell.
  ```powershell
  wsl -t NixOS #terminate
  #And then
  wsl -d NixOS #distribution
  ```

### Project Structure
```plaintext

my-nixos-config/
├── home/                  # User-specific Home Manager configurations
│   └── programs/          # Individual program configurations for Home Manager
│       ├── git/
│       ├── vim/           # Default
│       ├── nixvim/
│       ├── nu/
│       └── zsh/           # Default
├── lib/                   # Directory for utility functions and shared libraries
│   └── my-utils.nix
├── nixos/                 # NixOS system-level configurations
│   ├── modules/           # NixOS configuration modules
│   │   └── aliases.nix    # Aliases depends on system-level
│   └── platforms/         # Platform-specific NixOS configurations
│       ├── linux/
│       └── wsl/
├── flake.lock
├── flake.nix              # Main Flake file for defining NixOS and Home Manager
├── my-config.toml         # User-specific configuration variables. Check out the file for more details.
└── README.md              # Project documentation
```
- Most directories have their own default.nix file, which contains settings relevant to that directory.
- When you import a directory from .nix file, the default.nix file in that directory is automatically read.

## Tips
- You can add as many as you want here if you need.
  ```nix
  #./home/default.nix
    #Set packages for your session.
    packages = with pkgs; [
      wget
      curl
      ripgrep
      tree
      jq
      httpie
      htop
      fd
      tmux
    ];

    #Set aliases for user session.
    # shellAliases = {
    # };

    #Set environment variables for user session.
    # sessionVariables = {
    # };
  ```
- Global aliases can be added in ./nixos/modules/aliases.nix , and home aliases can be added for a config file of each shell , such as ./home/programs/zsh/default.nix.
  ```nix
  # ./nixos/modules/aliases.nix
  environment.shellAliases = {
    nrf = "sudo nixos-rebuild switch --flake";
    nrfd = "nrf .";
    nfc = "nix flake check";
    nfcd = "nfc .";
    npull = "pushd /home/${myConfig.user.name}/.dotfiles/${myConfig.nixos.bkp_conf_dir_name} && git stash push my-config.toml && git pull --rebase && git stash pop && popd";
    nupdate = "nrf /home/${myConfig.user.name}/${myConfig.nixos.bkp_conf_dir_name}";
  };

  #./home/programs/zsh/default.nix
  programs.zsh.shellAliases = {
      refresh = "source $HOME/.zshrc";
  };
  ```
- Updating the System: Run below to pull in the latest dependencies defined in the Flake.
  ```bash
  nix flake update
  ```
- Flake files verification(this is a command to check if the modified files are correct and valid before rebuilding flake)
  ```bash
  # current path
  nix flake check .
  #or more details
  nix flake check . --show-trace

  # Also --show-trace option can be added "nixos-rebuild" command
  # sudo nixos-rebuild switch --flake . --show-trace
  ```
- Rebuilding NixOS
  ```bash
  # current path
  sudo nixos-rebuild switch --flake .
  #or
  # specific path
  sudo nixos-rebuild switch --flake ./my-nixos-config
  ```

## Troubleshooting
- Permissions: Ensure you have the correct permissions for the files and directories.
- File System: If you encounter read-only file system errors, ensure the NixOS and Home directories are writable.
- Nix Commands: If Flake commands don’t work, confirm experimental-features = nix-command flakes is set in your Nix config.
- If you run "nixos-rebuild switch --flake ." and it says 'No such file or directory', Run "git add *"
- On Linux not WSL: As mentioned earlier, it has not been tested in a general Linux environment, but it is expected that there will be no problem if "./nixos/platforms/linux/default.nix" is ​​set properly.
- my-config.toml: Nix follows the principle of purity. Therefore, it cannot create an impurity situation where it loads external files or newly added files, so it has no choice but to manage files as they are. If you want to update to the latest version from github, I recommend using the simple and convenient "npull" alias(assuming only my-config.toml has changed).
- How to fix a clipboard not working in WSL environment:
  ```toml
  #./my-config.toml
  [programs]
  win32yank_path ="" # Change to the path such as "/mnt/c/Users/YOUR_NAME/scoop/apps/win32yank/0.1.1" after installing win32yank on windows somehow.
  ```

<details>
    <summary>Fixed issues</summary>

  - ~~After the first rebuild switch, you may see an error message like this. So far, there doesn't seem to be any critical issues.~~ This problem occurs when the base version of nixpkgs does not match the OS version (e.g. unstable).
    ```bash
    Error: Failed to open dbus connection

    Caused by:
        Failed to connect to socket /run/user/1000/bus: Connection refused
    ```
  </details>