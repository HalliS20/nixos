# dotfiles-clone-module.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dotfilesClone;
in {
  options.services.dotfilesClone = {
    enable = mkEnableOption "Dotfiles cloning service";

    user = mkOption {
      type = types.str;
      description = "The user for whom to clone the dotfiles";
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.cloneDotfiles = {
      text = ''
        ${pkgs.writeShellScript "clone-dotfiles" ''
          USER_HOME=$(getent passwd ${cfg.user} | cut -d: -f6)
          DOTFILES_DIR="$USER_HOME/Dotfiles"
          if [ ! -d "$DOTFILES_DIR" ]; then
            ${pkgs.git}/bin/git clone https://github.com/HalliS20/Dotfiles.git "$DOTFILES_DIR"
          else
            echo "Dotfiles directory already exists. Updating..."
            cd "$DOTFILES_DIR"
            ${pkgs.git}/bin/git pull
          fi
          chown -R ${cfg.user}:users "$DOTFILES_DIR"
        ''}
      '';
      deps = [];
    };
  };
}
