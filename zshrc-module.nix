# zshrc-module.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zshrcManager;
in {
  options.services.zshrcManager = {
    enable = mkEnableOption "Zshrc management service";

    user = mkOption {
      type = types.str;
      description = "The user for whom to manage the .zshrc file";
    };

    zshrcContent = mkOption {
      type = types.lines;
      default = "source Dotfiles/.zshrc";
      description = "The content to be written to the .zshrc file";
    };
  };

  config = mkIf cfg.enable {
    environment.etc."skel/.zshrc".text = cfg.zshrcContent;

    system.activationScripts.createZshrc = ''
      echo "Running zshrcManager activation script"
      USER_HOME=$(getent passwd ${cfg.user} | cut -d: -f6)
      echo "User home directory: $USER_HOME"
      
      if [ -z "$USER_HOME" ]; then
        echo "Error: Could not determine home directory for user ${cfg.user}"
        exit 1
      fi
      
      if [ ! -f "$USER_HOME/.zshrc" ]; then
        echo "Creating .zshrc file"
        cp /etc/skel/.zshrc "$USER_HOME/.zshrc"
        chown ${cfg.user}:users "$USER_HOME/.zshrc"
        echo ".zshrc file created successfully"
      else
        echo ".zshrc file already exists, not overwriting"
      fi
    '';
  };
}
