{ myConfig }:

{
  deps = [ "users" ];
  text = ''
    NIXOS_PATH="${myConfig.nixos.config_path}"
    BACKUP_DIR_NAME="${myConfig.nixos.bkp_conf_dir_name}"
    SUDO_USER=${myConfig.user.name}

    # Get the current user's home directory
    USER_HOME="/home/$SUDO_USER"
    if [ -z "$SUDO_USER" ]; then
      USER_HOME=$HOME
    fi

    DOTFILES_PATH="$USER_HOME/.dotfiles"
    DESTINATION_PATH="$DOTFILES_PATH/$BACKUP_DIR_NAME"

    if [ ! -d $DESTINATION_PATH ] && [ -d $NIXOS_PATH ]; then

      if [ ! -d $DOTFILES_PATH ]; then
        mkdir -p $DOTFILES_PATH
        chown $SUDO_USER:users $DOTFILES_PATH
      fi

      HOME_CONFIG_PATH="$USER_HOME/.config"

      if [ ! -d $HOME_CONFIG_PATH ]; then
        mkdir -p $HOME_CONFIG_PATH
        chown $SUDO_USER:users $HOME_CONFIG_PATH
      fi

      DESTINATION_FOR_LINK="$HOME_CONFIG_PATH/$BACKUP_DIR_NAME"

      # Create backup directory if it doesn't exist
      mkdir -p $DESTINATION_PATH

      # Copy configuration files
      cd $NIXOS_PATH
      cp -rf . $DESTINATION_PATH
      cd ..
      chown -R $SUDO_USER:users $DESTINATION_PATH

      #Create symlink in .config for easier access (optional)
      ln -sfn $DESTINATION_PATH $DESTINATION_FOR_LINK || true
    fi
  '';
}
