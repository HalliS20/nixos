{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#	inputs.home-manager.nixosModules.default
	./dotfiles-clone-module.nix
	./zshrc-module.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

###################### EXPERIMENTAL FEATURES #################
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.networkmanager.enable = true;

###################### LOCATION SETTINGS ####################
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };


############################## GUI AND RENDERING #########################
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true; ## GNOME
  services.xserver.desktopManager.gnome.enable = true;
  services.dbus.enable = true;    
  services.xserver.xkb = {
    layout = "us";
    variant = "";
 };

services.xserver.deviceSection = ''
  Option "TearFree" "true"
'';

boot.kernel.sysctl = {
  "vm.swappiness" = 10; # Lower value means less aggressive swapping
};

powerManagement.cpuFreqGovernor = "performance";

  swapDevices=[ {
  	device = "/swapfile";
    size = 16384;	
	}];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.graphics.enable32Bit = true;


############################### AUDIO ######################################
  hardware.pulseaudio.enable = false;
  hardware.pulseaudio.support32Bit = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

services.libinput.enable = true;


############################ USER ##############################
  users.users.hallitst = {
    isNormalUser = true;
    description = "Haraldur Steinar SKulason";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
     thunderbird
     git
    ];
  };


 services.dotfilesClone = {
	enable = true;
	user = "hallitst";
 };

services.zshrcManager = {
	enable=true;
	user="hallitst";
	zshrcContent = "source ~/Dotfiles/.zshrc";
};


############################################## PKGS
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
  	wget
	curl
	ffmpeg
	unzip
  # dev enviroment
	vim
	neovim
	kitty
	tmux
	git
	bash
	zsh
	neofetch
	wezterm
	lazygit
	bitwarden-desktop
	bitwarden-cli
 # cli apps
 	zoxide
	fzf
	oh-my-posh
	lsd
	nerdfonts
	github-cli
	glab
	htop
	gparted
	flatpak
# dev apps
	docker
	docker-compose
	jetbrains.clion
# programming languages
	go
	lua
	python310
	python311
	python312
	luaformatter
# programming language extras
	gcc
	clang
	nodejs
	yarn
	gnumake
	cmake
# Other
	xclip
	wl-clipboard
   	fontconfig
  	freetype
# Fonts
  (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  dejavu_fonts
  noto-fonts
];

  programs.neovim = {
    enable = true;
  };

  programs.firefox.enable = true;
  programs.zsh.enable=true;
fonts.fontconfig.enable = true;
services.flatpak.enable = true;

programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
};
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };


  environment.etc."xdg/kitty/kitty.conf".text = ''
    font_family MesloLGS NF
    font_size 11
    # Add other Kitty settings here
  '';


environment.etc."gitconfig".text = ''
  [safe]
    directory = /home/hallitst/.config/nvim
    directory = /home/hallitst/.config/wezterm
    directory = /home/hallitst/Dotfiles
   directory = /etc/nixos
'';



users.users.root = {
  shell = pkgs.zsh;
};

  system.stateVersion = "24.05"; # Did you read the comment?

}

