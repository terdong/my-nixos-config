{ myConfig, myUtils, ... }:
let
  files = myUtils.parseTomlToShellAsArrays myConfig.external.files;
in
{
  deps = [ "users" ];
  text = ''
    SUDO_USER=${myConfig.user.name}
    USER_HOME="/home/$SUDO_USER"
    echo "start copying external files"

    declare -a FILES=(${files})

    for ((i=0; i<''${#FILES[@]}; i+=3)); do
      if [ ! -e ''${FILES[i]} ]; then
        continue
      fi

      SOURCE=''${FILES[i]}
      TARGET=''${FILES[i+1]}
      PERMISSION=''${FILES[i+2]}
      if [ -z $PERMISSION ]; then
       PERMISSION="644"
      fi
      TARGET_WITH_HOME="$USER_HOME/$TARGET"
      TARGET_DIR="$(dirname $TARGET_WITH_HOME)"
      echo "File pair $((i/2)):"
      echo "  Source: $SOURCE   Target: $TARGET_WITH_HOME   Permission: $PERMISSION"

      if [ ! -d $TARGET_DIR ]; then
        mkdir -p $TARGET_DIR
      fi
      cp $SOURCE $TARGET_WITH_HOME

      if [ -f $SOURCE ]; then
        chmod $PERMISSION $TARGET_WITH_HOME
      elif [ -d $SOURCE ]; then
        chmod -R $PERMISSION $TARGET_WITH_HOME
      fi

      TOP_TARGET=$TARGET_WITH_HOME
      while true; do
        TOP_TARGET=$(dirname "$TOP_TARGET")
        [ "$TOP_TARGET" != "$USER_HOME" ] || break
      done
      chown -R $SUDO_USER:users $TOP_TARGET
    done
  '';
}
